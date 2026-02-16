#!/usr/bin/env ts-node
/**
 * MongoDB Backup and Restore Demo Script
 * 
 * This script demonstrates how to use the backup service programmatically.
 * Run with: npx ts-node scripts/backup-demo.ts
 */

import { BackupService } from '../src/common/services/backup.service';
import { NestFactory } from '@nestjs/core';
import { AppModule } from '../src/app.module';

async function runBackupDemo() {
    console.log('🚀 Starting MongoDB Backup Demo...\n');

    // Create the NestJS application context
    const app = await NestFactory.createApplicationContext(AppModule);
    const backupService = app.get(BackupService);

    try {
        // 1. Create a full database backup
        console.log('📦 Creating full database backup...');
        const backupResult = await backupService.backupDatabase({
            includeIndexes: true
        });

        console.log(`✅ Backup completed successfully!`);
        console.log(`   📁 Backup location: ${backupResult.backupPath}`);
        console.log(`   📊 Collections backed up: ${backupResult.collections.length}`);
        console.log(`   📄 Total documents: ${backupResult.totalDocuments}`);
        console.log(`   📅 Backup date: ${backupResult.backupDate.toISOString()}\n`);

        // 2. List available backups
        console.log('📋 Listing available backups...');
        const availableBackups = await backupService.listAvailableBackups();
        console.log(`Found ${availableBackups.length} backup(s):`);
        availableBackups.forEach((backup, index) => {
            console.log(`   ${index + 1}. ${backup.filename} (${backup.metadata.documentCount} documents)`);
        });
        console.log('');

        console.log('');

        // console.log(' Creating selective backup (users and events only)...');
        // const selectiveBackup = await backupService.backupDatabase({
        //     onlyCollections: ['users', 'events'],
        //     includeIndexes: false
        // });

        // 6. Cleanup old backups (keep only 2 most recent)
        console.log('🧹 Cleaning up old backups (keeping 2 most recent)...');
        const cleanup = await backupService.cleanupOldBackups(2);
        console.log(`   Deleted: ${cleanup.deletedCount} backups`);
        console.log(`   Kept: ${cleanup.keptCount} backups\n`);

        console.log('🎉 Demo completed successfully!');
        console.log('\n📝 To restore a backup, you can use:');
        console.log(`   backupService.restoreDatabase('${backupResult.backupPath}', { overwriteExisting: true })`);

    } catch (error) {
        console.error('❌ Demo failed:', error.message);
        if (error.stack) {
            console.error('Stack trace:', error.stack);
        }
    } finally {
        await app.close();
    }
}

// Run the demo
if (require.main === module) {
    runBackupDemo().catch(console.error);
}

export { runBackupDemo };