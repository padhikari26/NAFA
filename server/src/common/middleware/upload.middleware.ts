import { Injectable, NestMiddleware, BadRequestException } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';
import * as multer from 'multer';
import * as sharp from 'sharp';
import * as path from 'path';
import * as fs from 'fs-extra';
import { v4 as uuidv4 } from 'uuid';
import { PathUtils } from '../utils/path.utils';
import * as clamav from 'clamav.js';


export interface MulterRequest extends Request {
    files?: Express.Multer.File[];
    processedFiles?: ProcessedFile[];
}

export interface ProcessedFile {
    originalName: string;
    filename: string;
    path: string;
    size: number;
    mimetype: string;
    fieldname: string;
    compressed?: boolean;
    thumbnailPath?: string;
}

@Injectable()
export class UploadMiddleware implements NestMiddleware {
    private readonly uploadsPath = PathUtils.getUploadsPath();
    private readonly tempPath = PathUtils.getTempPath();
    private readonly imagesPath = path.join(this.uploadsPath, 'images');
    private readonly pdfsPath = path.join(this.uploadsPath, 'pdfs');

    // File size limits (in bytes)
    private readonly MAX_IMAGE_SIZE = 10 * 1024 * 1024; // 10MB
    private readonly MAX_PDF_SIZE = 50 * 1024 * 1024; // 50MB
    private readonly MAX_FILES = 10; // Maximum number of files per upload

    // Supported file types
    private readonly SUPPORTED_IMAGE_TYPES = [
        'image/jpeg',
        'image/jpg',
        'image/png',
        'image/webp',
        'image/gif'
    ];
    private readonly SUPPORTED_PDF_TYPES = ['application/pdf'];

    constructor() {
        this.ensureDirectoriesExist();
    }

    use(req: MulterRequest, res: Response, next: NextFunction) {
        const upload = multer({
            storage: multer.diskStorage({
                destination: (req, file, cb) => {
                    cb(null, this.tempPath);
                },
                filename: (req, file, cb) => {
                    const uniqueId = uuidv4();
                    const extension = path.extname(file.originalname);
                    const filename = `${uniqueId}${extension}`;
                    cb(null, filename);
                }
            }),
            limits: {
                fileSize: this.MAX_PDF_SIZE,
                files: this.MAX_FILES
            },
            fileFilter: (req, file, cb) => {
                if (this.isValidFileType(file.mimetype)) {
                    cb(null, true);
                } else {
                    cb(new BadRequestException(`Unsupported file type: ${file.mimetype}. Supported types: ${[...this.SUPPORTED_IMAGE_TYPES, ...this.SUPPORTED_PDF_TYPES].join(', ')}`));
                }
            }
        }).array('files', this.MAX_FILES);

        upload(req, res, async (err: any) => {
            if (err) {
                if (err instanceof multer.MulterError) {
                    switch (err.code) {
                        case 'LIMIT_FILE_SIZE':
                            return next(new BadRequestException('File size too large'));
                        case 'LIMIT_FILE_COUNT':
                            return next(new BadRequestException(`Maximum ${this.MAX_FILES} files allowed`));
                        case 'LIMIT_UNEXPECTED_FILE':
                            return next(new BadRequestException('Unexpected file field'));
                        default:
                            return next(new BadRequestException(`Upload error: ${err.message}`));
                    }
                }
                return next(err);
            }

            if (req.files && req.files.length > 0) {
                try {





                    req.processedFiles = await this.processUploadedFiles(req.files);
                    // Clean up temporary files
                    await this.cleanupTempFiles(req.files);
                } catch (error) {
                    // Clean up on error
                    await this.cleanupTempFiles(req.files);
                    return next(new BadRequestException(`File processing error: ${error.message}`));
                }
            }

            next();
        });
    }

    private async ensureDirectoriesExist(): Promise<void> {
        try {
            await fs.ensureDir(this.uploadsPath);
            await fs.ensureDir(this.tempPath);
            await fs.ensureDir(this.imagesPath);
            await fs.ensureDir(this.pdfsPath);
            await fs.ensureDir(path.join(this.imagesPath, 'thumbnails'));
        } catch (error) {
            console.error('Error creating upload directories:', error);
        }
    }

    private isValidFileType(mimetype: string): boolean {
        return [...this.SUPPORTED_IMAGE_TYPES, ...this.SUPPORTED_PDF_TYPES].includes(mimetype);
    }

    private async processUploadedFiles(files: Express.Multer.File[]): Promise<ProcessedFile[]> {
        const processedFiles: ProcessedFile[] = [];

        for (const file of files) {
            try {
                // Scan file for viruses using ClamAV
                const clamavPort = 3310;
                const clamavHost = process.env.CLAMAV_HOST || '127.0.0.1';
                await new Promise<void>((resolve, reject) => {
                    clamav.ping(clamavPort, clamavHost, (pingErr: any) => {
                        if (pingErr) {
                            return reject(new BadRequestException('ClamAV daemon is not reachable'));
                        }
                        clamav.scanFile(file.path, clamavPort, clamavHost, (err: any, _unused: any, malicious: boolean) => {
                            if (err) return reject(new BadRequestException(`ClamAV scan error: ${err.message}`));
                            if (malicious) return reject(new BadRequestException(`Virus detected in file ${file.originalname}`));
                            resolve();
                        });
                    });
                });

                let processedFile: ProcessedFile;

                if (this.SUPPORTED_IMAGE_TYPES.includes(file.mimetype)) {
                    // Validate image file size
                    if (file.size > this.MAX_IMAGE_SIZE) {
                        throw new Error(`Image file ${file.originalname} exceeds maximum size of ${this.MAX_IMAGE_SIZE / (1024 * 1024)}MB`);
                    }
                    processedFile = await this.processImage(file);
                } else if (this.SUPPORTED_PDF_TYPES.includes(file.mimetype)) {
                    // Validate PDF file size
                    if (file.size > this.MAX_PDF_SIZE) {
                        throw new Error(`PDF file ${file.originalname} exceeds maximum size of ${this.MAX_PDF_SIZE / (1024 * 1024)}MB`);
                    }
                    processedFile = await this.processPDF(file);
                } else {
                    throw new Error(`Unsupported file type: ${file.mimetype}`);
                }

                processedFiles.push(processedFile);
            } catch (error) {
                console.error(`Error processing file ${file.originalname}:`, error);
                throw error;
            }
        }

        return processedFiles;
    }

    private async processImage(file: Express.Multer.File): Promise<ProcessedFile> {
        const uniqueId = uuidv4();
        const extension = '.webp'; // Convert all images to WebP for better compression
        const filename = `${uniqueId}${extension}`;
        const finalPath = path.join(this.imagesPath, filename);
        const thumbnailFilename = `thumb_${filename}`;
        const thumbnailPath = path.join(this.imagesPath, 'thumbnails', thumbnailFilename);

        try {
            // Process and compress the main image
            const imageBuffer = await sharp(file.path)
                .webp({
                    quality: 85, // High quality compression
                    effort: 6   // Maximum compression effort
                })
                .resize(2048, 2048, {
                    fit: 'inside',
                    withoutEnlargement: true
                })
                .toBuffer();

            await fs.writeFile(finalPath, imageBuffer);

            // Generate thumbnail
            const thumbnailBuffer = await sharp(file.path)
                .webp({ quality: 80 })
                .resize(300, 300, {
                    fit: 'cover',
                    position: 'center'
                })
                .toBuffer();

            await fs.writeFile(thumbnailPath, thumbnailBuffer);

            // Get file stats
            const stats = await fs.stat(finalPath);

            return {
                originalName: file.originalname,
                filename,
                path: finalPath,
                size: stats.size,
                mimetype: 'image/webp',
                fieldname: file.fieldname,
                compressed: true,
                thumbnailPath
            };
        } catch (error) {
            console.error('Error processing image:', error);
            // Clean up any partially created files
            await this.safeDelete(finalPath);
            await this.safeDelete(thumbnailPath);
            throw new Error(`Failed to process image: ${error.message}`);
        }
    }

    private async processPDF(file: Express.Multer.File): Promise<ProcessedFile> {
        const uniqueId = uuidv4();
        const extension = '.pdf';
        const filename = `${uniqueId}${extension}`;
        const finalPath = path.join(this.pdfsPath, filename);

        try {
            // Ensure thumbnail directory exists
            await fs.ensureDir(path.join(this.pdfsPath, 'thumbnails'));

            // Copy PDF to final location
            await fs.copy(file.path, finalPath);

            // Get file stats
            const stats = await fs.stat(finalPath);

            return {
                originalName: file.originalname,
                filename,
                path: finalPath,
                size: stats.size,
                mimetype: file.mimetype,
                fieldname: file.fieldname,
                compressed: false,
            };
        } catch (error) {
            console.error('Error processing PDF:', error);
            await this.safeDelete(finalPath);
            throw new Error(`Failed to process PDF: ${error.message}`);
        }
    }

    private async cleanupTempFiles(files: Express.Multer.File[]): Promise<void> {
        for (const file of files) {
            await this.safeDelete(file.path);
        }
    }

    private async safeDelete(filePath: string): Promise<void> {
        try {
            if (await fs.pathExists(filePath)) {
                await fs.unlink(filePath);
            }
        } catch (error) {
            console.error(`Error deleting file ${filePath}:`, error);
        }
    }

    /**
     * Static method to get file URL for serving files
     */
    static getFileUrl(processedFile: ProcessedFile, baseUrl: string): string {
        const relativePath = processedFile.path.replace(PathUtils.getProjectRoot(), '');
        return `${baseUrl}${relativePath.replace(/\\/g, '/')}`;
    }

    /**
     * Static method to get thumbnail URL
     */
    static getThumbnailUrl(processedFile: ProcessedFile, baseUrl: string): string | undefined {
        if (!processedFile.thumbnailPath) return undefined;
        const relativePath = processedFile.thumbnailPath.replace(PathUtils.getProjectRoot(), '');
        return `${baseUrl}${relativePath.replace(/\\/g, '/')}`;
    }

    /**
     * Static method to delete uploaded files
     */
    static async deleteFile(processedFile: ProcessedFile): Promise<void> {
        try {
            if (await fs.pathExists(processedFile.path)) {
                await fs.unlink(processedFile.path);
            }
            if (processedFile.thumbnailPath && await fs.pathExists(processedFile.thumbnailPath)) {
                await fs.unlink(processedFile.thumbnailPath);
            }
        } catch (error) {
            console.error('Error deleting file:', error);
            throw error;
        }
    }
}
