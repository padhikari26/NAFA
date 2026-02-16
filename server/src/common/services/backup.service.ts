import * as fs from 'fs-extra';
import * as path from 'path';
import * as cron from 'node-cron';
import { Injectable, Logger } from '@nestjs/common';
import { InjectConnection } from '@nestjs/mongoose';
import { Connection } from 'mongoose';
import { PathUtils } from '../utils/path.utils';
import {
    BackupMetadata,
    CollectionBackupInfo,
    DatabaseBackupResult,
    RestoreResult,
    BackupFileInfo,
    RestoreOptions,
    BackupOptions
} from '../interfaces/backup.interface';

@Injectable()
export class BackupService {
    private readonly logger = new Logger(BackupService.name);
    private cronJob: cron.ScheduledTask | null = null;
    private readonly BACKUP_VERSION = '1.0.0';

    constructor(@InjectConnection() private readonly mongoConnection: Connection) { }

    /**
     * Get the backup directory path in the root directory (process.cwd())
     */
    private getBackupPath(): string {
        return path.join(process.cwd(), 'uploads_backup');
    }

    /**
     * Get the database backup directory path
     */
    private getDatabaseBackupPath(): string {
        return path.join(process.cwd(), 'database_backup');
    }

    /**
     * Get the uploads directory path from PathUtils
     */
    private getUploadsPath(): string {
        return PathUtils.getUploadsPath();
    }

    /**
     * Discover all collections in the MongoDB database
     */
    private async discoverCollections(): Promise<CollectionBackupInfo[]> {
        try {
            const db = this.mongoConnection.db;
            if (!db) {
                throw new Error('Database connection is not available');
            }

            const collections = await db.listCollections().toArray();

            const collectionInfos: CollectionBackupInfo[] = [];

            for (const collectionMeta of collections) {
                const collection = db.collection(collectionMeta.name);
                const documentCount = await collection.countDocuments();
                const indexes = await collection.indexes();

                collectionInfos.push({
                    name: collectionMeta.name,
                    documentCount,
                    indexes,
                    options: (collectionMeta as any).options || {}
                });
            }

            this.logger.log(`Discovered ${collectionInfos.length} collections: ${collectionInfos.map(c => c.name).join(', ')}`);
            return collectionInfos;
        } catch (error) {
            this.logger.error(`Failed to discover collections: ${error.message}`, error.stack);
            throw error;
        }
    }

    /**
     * Perform backup of uploads folder
     */
    async performBackup(): Promise<void> {
        try {
            // Step 1: Get the uploads directory path and move one directory up
            const uploadsPath = path.join(this.getUploadsPath());
            const backupPath = this.getBackupPath();

            // Check if uploads folder exists
            if (!await fs.pathExists(uploadsPath)) {
                this.logger.warn(`Uploads folder does not exist at: ${uploadsPath}`);
                return;
            }

            // Remove existing backup if it exists
            if (await fs.pathExists(backupPath)) {
                await fs.remove(backupPath);
                this.logger.log(`Removed existing backup at: ${backupPath}`);
            }

            // Copy uploads folder to backup location
            await fs.copy(uploadsPath, backupPath, {
                preserveTimestamps: true,
                dereference: true,
            });

            this.logger.log(`✅ Backup completed successfully from ${uploadsPath} to ${backupPath}`);
        } catch (error) {
            this.logger.error(`❌ Backup failed: ${error.message}`, error.stack);
            throw error;
        }
    }

    /**
     * Start the daily backup scheduler
     * Runs every day at 2:00 AM and backs up both files and database
     */
    startDailyBackup(): void {
        try {
            // If a cron job is already running, stop it first
            if (this.cronJob) {
                this.cronJob.stop();
                this.cronJob = null;
            }

            // Schedule backup to run daily at 2:00 AM
            this.cronJob = cron.schedule('0 2 * * *', async () => {
                this.logger.log('🔄 Starting scheduled daily backup (files + database)...');

                try {
                    // Backup uploads folder
                    await this.performBackup();
                    this.logger.log('✅ File backup completed');
                } catch (error) {
                    this.logger.error('❌ File backup failed:', error.message);
                }

                try {
                    // Backup MongoDB database
                    const dbBackupResult = await this.backupDatabase({
                        includeIndexes: true
                    });
                    this.logger.log(`✅ Database backup completed: ${dbBackupResult.totalDocuments} documents from ${dbBackupResult.collections.length} collections`);
                } catch (error) {
                    this.logger.error('❌ Database backup failed:', error.message);
                }

                try {
                    // Cleanup old database backups (keep last 7 days)
                    const cleanupResult = await this.cleanupOldBackups(7);
                    if (cleanupResult.deletedCount > 0) {
                        this.logger.log(`🧹 Cleaned up ${cleanupResult.deletedCount} old database backups`);
                    }
                } catch (error) {
                    this.logger.error('❌ Backup cleanup failed:', error.message);
                }

                this.logger.log('🎉 Scheduled daily backup sequence completed');
            }, {
                timezone: 'UTC'
            });

            this.logger.log('⏰ Daily backup scheduler started (runs at 2:00 AM UTC) - includes files + database + cleanup');

            // Perform initial backup on startup
            this.performInitialBackup();
        } catch (error) {
            this.logger.error(`❌ Failed to start backup scheduler: ${error.message}`, error.stack);
            throw error;
        }
    }

    /**
     * Stop the backup scheduler
     */
    stopBackupScheduler(): void {
        if (this.cronJob) {
            this.cronJob.stop();
            this.cronJob = null;
            this.logger.log('⏹️ Backup scheduler stopped');
        }
    }

    /**
     * Perform initial backup on startup (without blocking the application startup)
     * Includes both file and database backup
     */
    private performInitialBackup(): void {
        // Run initial backup asynchronously without blocking
        setImmediate(async () => {
            try {
                this.logger.log('🚀 Performing initial startup backup (files + database)...');

                // Backup uploads folder
                try {
                    await this.performBackup();
                    this.logger.log('✅ Initial file backup completed');
                } catch (error) {
                    this.logger.error('❌ Initial file backup failed:', error.message);
                }

                // Backup database
                try {
                    const dbBackupResult = await this.backupDatabase({
                        includeIndexes: true
                    });
                    this.logger.log(`✅ Initial database backup completed: ${dbBackupResult.totalDocuments} documents`);
                } catch (error) {
                    this.logger.error('❌ Initial database backup failed:', error.message);
                }

                this.logger.log('🎉 Initial startup backup sequence completed');
            } catch (error) {
                this.logger.error('❌ Initial backup sequence failed:', error.message);
            }
        });
    }

    /**
     * Backup a single collection to a JSON file
     */
    private async backupCollection(
        collectionName: string,
        backupDir: string,
        options: BackupOptions = {}
    ): Promise<BackupMetadata> {
        try {
            const db = this.mongoConnection.db;
            if (!db) {
                throw new Error('Database connection is not available');
            }

            const collection = db.collection(collectionName);
            const documents = await collection.find({}).toArray();

            const metadata: BackupMetadata = {
                collectionName,
                backupDate: new Date(),
                documentCount: documents.length,
                fileSize: 0,
                backupVersion: this.BACKUP_VERSION,
                databaseName: db.databaseName
            };

            // Create collection backup object
            const backupData = {
                metadata,
                documents,
                indexes: options.includeIndexes ? await collection.indexes() : []
            };

            // Write to file
            const filename = `${collectionName}_${new Date().toISOString().replace(/[:.]/g, '-')}.json`;
            const filePath = path.join(backupDir, filename);

            await fs.ensureDir(backupDir);
            await fs.writeJson(filePath, backupData, { spaces: 2 });

            // Update file size in metadata
            const stats = await fs.stat(filePath);
            metadata.fileSize = stats.size;

            // Update the metadata in the file
            backupData.metadata = metadata;
            await fs.writeJson(filePath, backupData, { spaces: 2 });

            this.logger.log(`✅ Backed up collection '${collectionName}': ${documents.length} documents (${(stats.size / 1024 / 1024).toFixed(2)} MB)`);

            return metadata;
        } catch (error) {
            this.logger.error(`❌ Failed to backup collection '${collectionName}': ${error.message}`, error.stack);
            throw error;
        }
    }

    /**
     * Backup all MongoDB collections to separate files
     */
    async backupDatabase(options: BackupOptions = {}): Promise<DatabaseBackupResult> {
        const startTime = Date.now();
        const backupDate = new Date();
        const backupDir = path.join(this.getDatabaseBackupPath(), `backup_${backupDate.toISOString().replace(/[:.]/g, '-')}`);

        let collections: CollectionBackupInfo[] = [];
        let totalDocuments = 0;
        const errors: string[] = [];

        try {
            this.logger.log('🔄 Starting comprehensive database backup...');

            // Discover collections
            collections = await this.discoverCollections();

            // Filter collections based on options
            let collectionsToBackup = collections;
            if (options.onlyCollections && options.onlyCollections.length > 0) {
                collectionsToBackup = collections.filter(c => options.onlyCollections!.includes(c.name));
            }
            if (options.skipCollections && options.skipCollections.length > 0) {
                collectionsToBackup = collectionsToBackup.filter(c => !options.skipCollections!.includes(c.name));
            }

            this.logger.log(`📋 Will backup ${collectionsToBackup.length} collections: ${collectionsToBackup.map(c => c.name).join(', ')}`);

            // Backup each collection
            for (const collectionInfo of collectionsToBackup) {
                try {
                    const metadata = await this.backupCollection(collectionInfo.name, backupDir, options);
                    totalDocuments += metadata.documentCount;
                } catch (error) {
                    const errorMsg = `Failed to backup collection '${collectionInfo.name}': ${error.message}`;
                    errors.push(errorMsg);
                    this.logger.error(errorMsg);
                }
            }

            // Create backup summary
            const summaryData = {
                backupDate,
                backupVersion: this.BACKUP_VERSION,
                databaseName: this.mongoConnection.db?.databaseName || 'unknown',
                collections: collectionsToBackup.map(c => ({
                    name: c.name,
                    documentCount: c.documentCount,
                    hasIndexes: options.includeIndexes || false
                })),
                totalDocuments,
                totalCollections: collectionsToBackup.length,
                backupDurationMs: Date.now() - startTime,
                errors: errors.length > 0 ? errors : undefined
            };

            await fs.writeJson(path.join(backupDir, 'backup-summary.json'), summaryData, { spaces: 2 });

            const duration = ((Date.now() - startTime) / 1000).toFixed(2);
            this.logger.log(`✅ Database backup completed in ${duration}s. Backed up ${totalDocuments} documents from ${collectionsToBackup.length} collections.`);

            if (errors.length > 0) {
                this.logger.warn(`⚠️ Backup completed with ${errors.length} errors.`);
            }

            return {
                success: errors.length === 0,
                backupPath: backupDir,
                collections: collectionsToBackup,
                totalDocuments,
                backupDate,
                errors: errors.length > 0 ? errors : undefined
            };

        } catch (error) {
            this.logger.error('❌ Database backup failed:', error.message);
            throw error;
        }
    }
    /**
     * List available backup directories
     */
    async listAvailableBackups(): Promise<BackupFileInfo[]> {
        try {
            const backupBaseDir = this.getDatabaseBackupPath();

            if (!await fs.pathExists(backupBaseDir)) {
                return [];
            }

            const backupDirs = await fs.readdir(backupBaseDir);
            const backupInfos: BackupFileInfo[] = [];

            for (const dir of backupDirs) {
                const dirPath = path.join(backupBaseDir, dir);
                const stat = await fs.stat(dirPath);

                if (stat.isDirectory()) {
                    const summaryPath = path.join(dirPath, 'backup-summary.json');

                    if (await fs.pathExists(summaryPath)) {
                        try {
                            const summary = await fs.readJson(summaryPath);

                            backupInfos.push({
                                filename: dir,
                                collectionName: 'all',
                                metadata: {
                                    collectionName: 'all',
                                    backupDate: new Date(summary.backupDate),
                                    documentCount: summary.totalDocuments,
                                    fileSize: 0,
                                    backupVersion: summary.backupVersion,
                                    databaseName: summary.databaseName
                                },
                                filePath: dirPath,
                                exists: true
                            });
                        } catch (error) {
                            this.logger.warn(`Failed to read backup summary for ${dir}: ${error.message}`);
                        }
                    }
                }
            }

            return backupInfos.sort((a, b) => b.metadata.backupDate.getTime() - a.metadata.backupDate.getTime());
        } catch (error) {
            this.logger.error(`Failed to list available backups: ${error.message}`, error.stack);
            throw error;
        }
    }

    /**
     * Clean up old backup directories (keeps only the latest N backups)
     */
    async cleanupOldBackups(keepCount: number = 5): Promise<{ deletedCount: number; keptCount: number }> {
        try {
            const backups = await this.listAvailableBackups();

            if (backups.length <= keepCount) {
                this.logger.log(`No cleanup needed. Found ${backups.length} backups, keeping ${keepCount}`);
                return { deletedCount: 0, keptCount: backups.length };
            }

            const backupsToDelete = backups.slice(keepCount);
            let deletedCount = 0;

            for (const backup of backupsToDelete) {
                try {
                    await fs.remove(backup.filePath);
                    deletedCount++;
                    this.logger.log(`🗑️ Deleted old backup: ${backup.filename}`);
                } catch (error) {
                    this.logger.error(`Failed to delete backup ${backup.filename}: ${error.message}`);
                }
            }
            this.logger.log(`🧹 Cleanup completed: deleted ${deletedCount} old backups, kept ${keepCount} recent backups`);
            return { deletedCount, keptCount: backups.length - deletedCount };
        } catch (error) {
            this.logger.error(`Failed to cleanup old backups: ${error.message}`, error.stack);
            throw error;
        }
    }

    async getBackupStatus(): Promise<{
        backupExists: boolean;
        backupPath: string;
        uploadsPath: string;
        lastModified?: Date;
        size?: number;
    }> {
        const backupPath = this.getBackupPath();
        const uploadsPath = this.getUploadsPath();
        const backupExists = await fs.pathExists(backupPath);

        let lastModified: Date | undefined;
        let size: number | undefined;

        if (backupExists) {
            try {
                const stats = await fs.stat(backupPath);
                lastModified = stats.mtime;
                size = stats.size;
            } catch (error) {
                this.logger.warn(`Could not get backup stats: ${error.message}`);
            }
        }

        return {
            backupExists,
            backupPath,
            uploadsPath,
            lastModified,
            size,
        };
    }
}