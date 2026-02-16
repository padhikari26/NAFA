import { Controller, Get, Post, Body, Param, Query, ValidationPipe, UsePipes } from '@nestjs/common';
import { BackupService } from '../services/backup.service';
import { BackupOptions, RestoreOptions } from '../interfaces/backup.interface';
import { BackupOptionsDto, RestoreOptionsDto } from '../dto/backup.dto';

@Controller('backup')
export class BackupController {
    constructor(private readonly backupService: BackupService) { }

    @Get('status')
    async getBackupStatus() {
        const status = await this.backupService.getBackupStatus();
        return {
            message: 'Backup status retrieved successfully',
            data: status,
        };
    }

    @Get('trigger')
    async triggerBackup() {
        try {
            await this.backupService.performBackup();
            return {
                message: 'Backup completed successfully',
                success: true,
            };
        } catch (error) {
            return {
                message: 'Backup failed',
                success: false,
                error: error.message,
            };
        }
    }

    @Post('database/backup')
    @UsePipes(new ValidationPipe({ transform: true }))
    async backupDatabase(@Body() options: BackupOptionsDto = {}) {
        try {
            const result = await this.backupService.backupDatabase(options as BackupOptions);
            return {
                message: 'Database backup completed successfully',
                success: result.success,
                data: result,
            };
        } catch (error) {
            return {
                message: 'Database backup failed',
                success: false,
                error: error.message,
            };
        }
    }

    @Get('database/list')
    async listAvailableBackups() {
        try {
            const backups = await this.backupService.listAvailableBackups();
            return {
                message: 'Available backups retrieved successfully',
                success: true,
                data: backups,
            };
        } catch (error) {
            return {
                message: 'Failed to retrieve available backups',
                success: false,
                error: error.message,
            };
        }
    }

    @Get('database/status')
    async getDatabaseBackupStatus() {
        try {
            const backups = await this.backupService.listAvailableBackups();
            const latestBackup = backups.length > 0 ? backups[0] : null;

            return {
                message: 'Database backup status retrieved successfully',
                success: true,
                data: {
                    hasBackups: backups.length > 0,
                    totalBackups: backups.length,
                    latestBackup: latestBackup ? {
                        date: latestBackup.metadata.backupDate,
                        documentCount: latestBackup.metadata.documentCount,
                        path: latestBackup.filePath
                    } : null,
                    allBackups: backups
                },
            };
        } catch (error) {
            return {
                message: 'Failed to retrieve database backup status',
                success: false,
                error: error.message,
            };
        }
    }

}