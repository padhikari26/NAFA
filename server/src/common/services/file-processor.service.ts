import { Injectable, Logger } from '@nestjs/common';
import { FileType, ProcessedFile, UploadModule } from '../interfaces/upload.interface';
import { uploadConfig } from '../config/upload.config';
import { PathUtils } from '../utils/path.utils';
import * as path from 'path';
import * as fs from 'fs-extra';
import * as sharp from 'sharp';
import { v4 as uuidv4 } from 'uuid';
import { WinstonLogger } from '../logger/winston-logger.service';

@Injectable()
export class FileProcessorService {


    constructor(
        private readonly logger: WinstonLogger
    ) {

    }

    async processFile(
        file: Express.Multer.File,
        fileType: FileType,
        module: UploadModule
    ): Promise<ProcessedFile> {
        const startTime = Date.now();
        const fileId = uuidv4();

        try {
            let processedFile: ProcessedFile;

            switch (fileType) {
                case FileType.IMAGE:
                    processedFile = await this.processImage(file, module, fileId);
                    break;
                case FileType.VIDEO:
                    processedFile = await this.processVideo(file, module, fileId);
                    break;
                case FileType.DOCUMENT:
                    processedFile = await this.processDocument(file, module, fileId);
                    break;
                default:
                    throw new Error(`Unsupported file type: ${fileType}`);
            }

            const processingTime = Date.now() - startTime;
            this.logger.log(`File ${file.originalname} processed in ${processingTime}ms`);

            return processedFile;
        } catch (error) {
            this.logger.error(`Failed to process file ${file.originalname}: ${error.message}`);
            throw error;
        }
    }

    private async processImage(
        file: Express.Multer.File,
        module: UploadModule,
        fileId: string
    ): Promise<ProcessedFile> {
        const filename = `${fileId}.webp`;
        const modulePath = this.getModulePath(module);
        const finalPath = path.join(modulePath, 'images', filename);
        const thumbnailFilename = `thumb_${filename}`;
        const thumbnailPath = path.join(modulePath, 'images', 'thumbnails', thumbnailFilename);

        await this.ensureDirectoryExists(path.dirname(finalPath));
        await this.ensureDirectoryExists(path.dirname(thumbnailPath));

        try {
            let imageBuffer: Buffer = this.getFileBuffer(file);

            // Process and compress the main image
            if (uploadConfig.processing.enableCompression) {
                const processedBuffer = await sharp(imageBuffer)
                    .webp({
                        quality: uploadConfig.processing.imageQuality,
                        effort: 6
                    })
                    .resize(2048, 2048, {
                        fit: 'inside',
                        withoutEnlargement: true
                    })
                    .toBuffer();

                await fs.writeFile(finalPath, processedBuffer);
            } else {
                await fs.writeFile(finalPath, imageBuffer);
            }

            // Generate thumbnail
            const thumbnailBuffer = await sharp(imageBuffer)
                .webp({ quality: 80 })
                .resize(uploadConfig.processing.thumbnailSize, uploadConfig.processing.thumbnailSize, {
                    fit: 'cover',
                    position: 'center'
                })
                .toBuffer();

            await fs.writeFile(thumbnailPath, thumbnailBuffer);

            const stats = await fs.stat(finalPath);

            return {
                id: fileId,
                originalName: file.originalname,
                filename,
                path: this.getRelativePath(finalPath),
                size: stats.size,
                mimetype: 'image/webp',
                type: FileType.IMAGE,
                module,
                compressed: uploadConfig.processing.enableCompression,
                thumbnailPath: this.getRelativePath(thumbnailPath),
                metadata: {
                    originalSize: file.size,
                    compressionRatio: file.size / stats.size,
                }
            };
        } catch (error) {
            await this.cleanupFiles([finalPath, thumbnailPath]);
            throw new Error(`Failed to process image: ${error.message}`);
        }
    }

    private async processVideo(
        file: Express.Multer.File,
        module: UploadModule,
        fileId: string
    ): Promise<ProcessedFile> {
        const extension = path.extname(file.originalname);
        const filename = `${fileId}${extension}`;
        const modulePath = this.getModulePath(module);
        const finalPath = path.join(modulePath, 'videos', filename);

        await this.ensureDirectoryExists(path.dirname(finalPath));

        try {
            const buffer = this.getFileBuffer(file);
            await fs.writeFile(finalPath, buffer);

            const stats = await fs.stat(finalPath);

            return {
                id: fileId,
                originalName: file.originalname,
                filename,
                path: this.getRelativePath(finalPath),
                size: stats.size,
                mimetype: file.mimetype,
                type: FileType.VIDEO,
                module,
                metadata: {
                    duration: null, // Could be extracted using ffprobe in production
                }
            };
        } catch (error) {
            await this.cleanupFiles([finalPath]);
            throw new Error(`Failed to process video: ${error.message}`);
        }
    }

    private async processDocument(
        file: Express.Multer.File,
        module: UploadModule,
        fileId: string
    ): Promise<ProcessedFile> {
        const extension = path.extname(file.originalname);
        const filename = `${fileId}${extension}`;
        const modulePath = this.getModulePath(module);
        const finalPath = path.join(modulePath, 'documents', filename);

        await this.ensureDirectoryExists(path.dirname(finalPath));

        try {
            const buffer = this.getFileBuffer(file);
            await fs.writeFile(finalPath, buffer);

            const stats = await fs.stat(finalPath);

            return {
                id: fileId,
                originalName: file.originalname,
                filename,
                path: this.getRelativePath(finalPath),
                size: stats.size,
                mimetype: file.mimetype,
                type: FileType.DOCUMENT,
                module,
                metadata: {
                    pageCount: null, // Could be extracted using pdf-parse in production
                }
            };
        } catch (error) {
            await this.cleanupFiles([finalPath]);
            throw new Error(`Failed to process document: ${error.message}`);
        }
    }

    private getFileBuffer(file: Express.Multer.File): Buffer {
        if (file.buffer) {
            return file.buffer;
        } else if (file.path) {
            return fs.readFileSync(file.path);
        } else {
            throw new Error('No file data available');
        }
    }

    private getModulePath(module: UploadModule): string {
        return path.join(PathUtils.getProjectRoot(), uploadConfig.storage.basePath, module);
    }

    private getRelativePath(absolutePath: string): string {
        return PathUtils.getRelativePath(absolutePath);
    }

    private async ensureDirectoryExists(dirPath: string): Promise<void> {
        await fs.ensureDir(dirPath);
    }

    private async cleanupFiles(filePaths: string[]): Promise<void> {
        for (const filePath of filePaths) {
            try {
                if (await fs.pathExists(filePath)) {
                    await fs.unlink(filePath);
                }
            } catch (error) {
                this.logger.warn(`Failed to cleanup file ${filePath}: ${error.message}`);
            }
        }
    }
}
