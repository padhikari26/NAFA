import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { MulterModule } from '@nestjs/platform-express';
import { UploadedFile, UploadedFileSchema } from '../schemas/uploaded-file.schema';
import { UploadService } from '../services/main-upload.service';
import { FileValidationService } from '../services/file-validation.service';
import { FileProcessorService } from '../services/file-processor.service';
import { uploadConfig } from '../config/upload.config';
import { PathUtils } from '../utils/path.utils';
import { diskStorage } from 'multer';
import * as path from 'path';
import { v4 as uuidv4 } from 'uuid';

@Module({
    imports: [
        MongooseModule.forFeature([
            { name: UploadedFile.name, schema: UploadedFileSchema }
        ]),
        MulterModule.register({
            storage: diskStorage({
                destination: (req, file, cb) => {
                    // Files will be stored temporarily, then moved by the service
                    cb(null, PathUtils.getTempPath());
                },
                filename: (req, file, cb) => {
                    const uniqueName = `temp_${uuidv4()}_${file.originalname}`;
                    cb(null, uniqueName);
                },
            }),
            limits: {
                fileSize: uploadConfig.maxFileSize.image, // Default to image size, will be validated per type
                files: uploadConfig.security.maxFilesPerRequest,
            },
            fileFilter: (req, file, cb) => {
                // Basic filtering - detailed validation happens in service
                const allowedMimes = [
                    ...uploadConfig.allowedMimeTypes.images,
                    ...uploadConfig.allowedMimeTypes.videos,
                    ...uploadConfig.allowedMimeTypes.documents,
                ];

                if (allowedMimes.includes(file.mimetype)) {
                    cb(null, true);
                } else {
                    cb(new Error(`File type ${file.mimetype} is not allowed`), false);
                }
            },
        }),
    ],
    providers: [
        UploadService,
        FileValidationService,
        FileProcessorService,
    ],
    exports: [
        UploadService,
        FileValidationService,
        FileProcessorService,
    ],
})
export class uploadModule { }
