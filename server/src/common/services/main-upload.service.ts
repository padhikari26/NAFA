import { Injectable, BadRequestException } from '@nestjs/common';
import { WinstonLogger } from '../logger/winston-logger.service';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { UploadedFile, UploadedFileDocument } from '../schemas/uploaded-file.schema';
import {
    ProcessedFile,
    UploadResult,
    UploadError,
    UploadModule,
    UploadOptions
} from '../interfaces/upload.interface';
import { FileValidationService } from './file-validation.service';
import { FileProcessorService } from './file-processor.service';
import { uploadConfig } from '../config/upload.config';
import { PathUtils } from '../utils/path.utils';
import * as fs from 'fs-extra';
import * as path from 'path';

@Injectable()
export class UploadService {
    /**
     * Utility to clean up uploaded files if a post-upload error occurs.
     * Usage: Call this in your catch block after uploadFiles if you want to remove orphaned files.
     */
    async cleanupUploadedFiles(uploadResult: UploadResult): Promise<void> {
        if (uploadResult && uploadResult.files && uploadResult.files.length > 0) {
            const fileIds = uploadResult.files.map(f => f.id);
            await this.deleteFiles(fileIds);
            this.logger.log(`Cleaned up ${fileIds.length} orphaned uploaded files.`);
        }
    }
    constructor(
        @InjectModel(UploadedFile.name) private uploadedFileModel: Model<UploadedFileDocument>,
        private readonly fileValidationService: FileValidationService,
        private readonly fileProcessorService: FileProcessorService,
        private readonly logger: WinstonLogger
    ) { }


    async uploadFiles(files: Express.Multer.File[], options: UploadOptions): Promise<UploadResult> {
        // Enforce multiple property
        if (options.multiple === false && files.length !== 1) {
            throw new BadRequestException('Exactly one file must be uploaded for single upload.');
        }
        if (options.multiple === true && files.length < 1) {
            throw new BadRequestException('At least one file must be uploaded for multiple upload.');
        }
        const startTime = Date.now();
        this.logger.log(`Starting upload of ${files.length} files for path: ${options.path}`);

        // Determine max files allowed
        const maxFilesAllowed = options.maxFileNumber ?? uploadConfig.security.maxFilesPerRequest;
        if (files.length > maxFilesAllowed) {
            throw new BadRequestException(
                `Too many files. Maximum ${maxFilesAllowed} files allowed per request.`
            );
        }

        const processedFiles: ProcessedFile[] = [];
        const errors: UploadError[] = [];
        let totalSize = 0;

        for (const file of files) {
            try {
                // Validate file type
                const ext = path.extname(file.originalname).toLowerCase();
                let valid = false;
                if (options.type === 'all') {
                    valid = true;
                } else if (options.type === 'photo') {
                    valid = ['.jpg', '.jpeg', '.png', '.gif', '.webp'].includes(ext);
                } else if (options.type === 'video') {
                    valid = ['.mp4', '.mov', '.avi'].includes(ext);
                } else if (options.type === 'document') {
                    valid = ['.pdf', '.doc', '.docx', '.xls', '.xlsx'].includes(ext);
                } else if (options.type === 'photo-video') {
                    valid = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.mp4', '.mov', '.avi'].includes(ext);
                }
                if (!valid) {
                    const error = {
                        filename: file.originalname,
                        error: `Invalid file type: ${file.originalname}`,
                        code: 'VALIDATION_FAILED'
                    };
                    this.logger.error(`File validation failed: ${error.error}`);
                    return {
                        success: false,
                        files: [],
                        errors: [error],
                        totalSize: 0,
                        processingTime: Date.now() - startTime
                    };
                }
                const { isValid, errors: validationErrors, fileType } = this.fileValidationService.validateFile(file);
                if (!isValid) {
                    const error = {
                        filename: file.originalname,
                        error: `Validation failed: ${validationErrors.join(', ')}`,
                        code: 'VALIDATION_FAILED'
                    };
                    this.logger.error(`File validation failed: ${error.error}`);
                    return {
                        success: false,
                        files: [],
                        errors: [error],
                        totalSize: 0,
                        processingTime: Date.now() - startTime
                    };
                }
                // Process file
                const processedFile = await this.fileProcessorService.processFile(
                    file,
                    fileType!,
                    options.path as any
                );

                const savedFile = await this.saveFileMetadata(processedFile);
                processedFile.id = (savedFile._id as any).toString();
                processedFiles.push(processedFile);
                totalSize += processedFile.size;
                this.logger.log(`Successfully processed file: ${file.originalname}`);
            } catch (error) {
                this.logger.error(`Failed to process file ${file.originalname}: ${error.message}`);
                const uploadError = {
                    filename: file.originalname,
                    error: error.message,
                    code: 'PROCESSING_FAILED'
                };
                return {
                    success: false,
                    files: [],
                    errors: [uploadError],
                    totalSize: 0,
                    processingTime: Date.now() - startTime
                };
            }
        }

        const processingTime = Date.now() - startTime;
        const result: UploadResult = {
            success: processedFiles.length > 0,
            files: processedFiles,
            errors,
            totalSize,
            processingTime
        };
        this.logger.log(
            `Upload completed: ${processedFiles.length} successful, ${errors.length} failed, ${processingTime}ms`
        );
        return result;
    }

    async deleteFiles(fileIds: string[]): Promise<{ deleted: number; errors: string[] }> {
        this.logger.log(`Deleting ${fileIds.length} files`);

        const files = await this.uploadedFileModel.find({ _id: { $in: fileIds } });
        const errors: string[] = [];
        let deleted = 0;

        for (const file of files) {
            try {
                // Delete physical files
                await this.deletePhysicalFile(file.path);
                if (file.thumbnailPath) {
                    await this.deletePhysicalFile(file.thumbnailPath);
                }

                // Delete from database
                await this.uploadedFileModel.deleteOne({ _id: file._id });
                deleted++;

                this.logger.log(`Deleted file: ${file.filename}`);

            } catch (error) {
                const errorMsg = `Failed to delete file ${file.filename}: ${error.message}`;
                this.logger.error(errorMsg);
                errors.push(errorMsg);
            }
        }

        return { deleted, errors };
    }

    async getFilesByModule(module: UploadModule): Promise<UploadedFileDocument[]> {
        return await this.uploadedFileModel.find({ uploadedFrom: module });
    }

    async getFileById(fileId: string): Promise<UploadedFileDocument | null> {
        return await this.uploadedFileModel.findById(fileId);
    }

    generateFileUrl(filePath: string, baseUrl: string): string {
        // filePath is now relative (e.g., uploads/events/images/file.webp)
        // Ensure baseUrl doesn't end with slash and filePath doesn't start with slash
        const cleanBaseUrl = baseUrl.replace(/\/$/, '');
        const cleanFilePath = filePath.replace(/^\//, '');
        return `${cleanBaseUrl}/${cleanFilePath}`;
    }

    private async saveFileMetadata(processedFile: ProcessedFile): Promise<UploadedFileDocument> {
        const uploadedFile = new this.uploadedFileModel({
            filename: processedFile.filename,
            originalName: processedFile.originalName,
            mimetype: processedFile.mimetype,
            size: processedFile.size,
            path: processedFile.path,
            thumbnailPath: processedFile.thumbnailPath,
            type: processedFile.type,
            uploadedFrom: processedFile.module,
            compressed: processedFile.compressed,
        });

        return await uploadedFile.save();
    }

    private async deletePhysicalFile(filePath: string): Promise<void> {
        // Convert relative path to absolute path for file operations
        const absolutePath = path.isAbsolute(filePath)
            ? filePath
            : path.join(PathUtils.getProjectRoot(), filePath);

        if (await fs.pathExists(absolutePath)) {
            await fs.unlink(absolutePath);
        }
    }
}
