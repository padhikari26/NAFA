import { Injectable, Logger } from '@nestjs/common';
import { uploadConfig } from '../config/upload.config';
import { FileType, FileValidationResult } from '../interfaces/upload.interface';
import * as path from 'path';
import { WinstonLogger } from '../logger/winston-logger.service';

@Injectable()
export class FileValidationService {
    constructor(
        private readonly logger: WinstonLogger
    ) {

    }

    validateFile(file: Express.Multer.File): FileValidationResult {
        const errors: string[] = [];
        let fileType: FileType | null = null;

        // Check if file exists
        if (!file) {
            errors.push('No file provided');
            return { isValid: false, errors, fileType };
        }

        // Validate file extension
        const ext = path.extname(file.originalname).toLowerCase();
        if (!uploadConfig.security.allowedFileExtensions.includes(ext)) {
            errors.push(`File extension ${ext} is not allowed`);
        }

        // Determine and validate file type
        fileType = this.determineFileType(file.mimetype);
        if (!fileType) {
            errors.push(`Unsupported file type: ${file.mimetype}`);
        }

        // Validate file size
        if (fileType) {
            const maxSize = uploadConfig.maxFileSize[fileType];
            if (file.size > maxSize) {
                errors.push(`File size ${this.formatFileSize(file.size)} exceeds maximum allowed size ${this.formatFileSize(maxSize)}`);
            }
        }

        // Validate filename
        if (this.hasInvalidCharacters(file.originalname)) {
            errors.push('Filename contains invalid characters');
        }

        // Additional security checks
        if (this.isPotentiallyMalicious(file)) {
            errors.push('File appears to be potentially malicious');
        }

        const isValid = errors.length === 0;

        this.logger.log(`File validation ${isValid ? 'passed' : 'failed'} for ${file.originalname}`);
        if (!isValid) {
            this.logger.warn(`Validation errors: ${errors.join(', ')}`);
        }

        return { isValid, errors, fileType };
    }

    private determineFileType(mimetype: string): FileType | null {
        if (uploadConfig.allowedMimeTypes.images.includes(mimetype)) {
            return FileType.IMAGE;
        }
        if (uploadConfig.allowedMimeTypes.videos.includes(mimetype)) {
            return FileType.VIDEO;
        }
        if (uploadConfig.allowedMimeTypes.documents.includes(mimetype)) {
            return FileType.DOCUMENT;
        }
        return null;
    }

    private hasInvalidCharacters(filename: string): boolean {
        // Check for potentially dangerous characters
        const dangerousChars = /[<>:"/\\|?*\x00-\x1f]/;
        return dangerousChars.test(filename);
    }

    private isPotentiallyMalicious(file: Express.Multer.File): boolean {
        // Basic malicious file detection
        const suspiciousExtensions = ['.exe', '.bat', '.cmd', '.scr', '.pif', '.com'];
        const ext = path.extname(file.originalname).toLowerCase();

        // Check for double extensions (like file.pdf.exe)
        const parts = file.originalname.split('.');
        if (parts.length > 2) {
            for (const part of parts) {
                if (suspiciousExtensions.includes(`.${part.toLowerCase()}`)) {
                    return true;
                }
            }
        }

        return false;
    }

    private formatFileSize(bytes: number): string {
        const sizes = ['Bytes', 'KB', 'MB', 'GB'];
        if (bytes === 0) return '0 Bytes';
        const i = Math.floor(Math.log(bytes) / Math.log(1024));
        return Math.round(bytes / Math.pow(1024, i) * 100) / 100 + ' ' + sizes[i];
    }
}
