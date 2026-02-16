import { Injectable, NestMiddleware, BadRequestException } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';
import * as multer from 'multer';
import * as path from 'path';
import * as fs from 'fs-extra';
import { v4 as uuidv4 } from 'uuid';
import { PathUtils } from '../utils/path.utils';
import { UploadService } from '../services/main-upload.service';

export interface MulterRequest extends Request {
    files?: Express.Multer.File[];
}

@Injectable()
export class UploadMiddleware implements NestMiddleware {
    private readonly tempPath = PathUtils.getTempPath();
    private readonly MAX_FILES = 20; // Maximum number of files per upload

    constructor(private readonly mainUploadService: UploadService) {
        this.ensureDirectoriesExist();
    }

    private async ensureDirectoriesExist(): Promise<void> {
        try {
            await fs.ensureDir(this.tempPath);
        } catch (error) {
            console.error('Error creating temp directory:', error);
        }
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
                fileSize: 100 * 1024 * 1024, // 100MB max (will be validated per file type)
                files: this.MAX_FILES
            },
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

            next();
        });
    }
}
