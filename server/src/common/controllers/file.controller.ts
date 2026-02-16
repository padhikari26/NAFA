import { Controller, Get, Param, Res, BadRequestException } from '@nestjs/common';
import { Response } from 'express';
import { Public } from '../decorators/public.decorator';
import { PathUtils } from '../utils/path.utils';
import * as path from 'path';
import * as fs from 'fs-extra';

@Controller('files')
export class FileController {

    @Public()
    @Get(':module/:type/:filename')
    async serveFile(
        @Param('module') module: string,
        @Param('type') type: string,
        @Param('filename') filename: string,
        @Res() res: Response
    ) {
        try {
            // Validate module and type
            const allowedModules = ['events', 'blogs', 'members', 'notifications'];
            const allowedTypes = ['images', 'videos', 'documents', 'thumbnails'];

            if (!allowedModules.includes(module)) {
                throw new BadRequestException('Invalid module');
            }

            if (!allowedTypes.includes(type)) {
                throw new BadRequestException('Invalid file type');
            }

            let filePath: string;

            // Handle thumbnails path
            if (type === 'thumbnails') {
                filePath = path.join(PathUtils.getProjectRoot(), 'uploads', module, 'images', 'thumbnails', filename);
            } else {
                filePath = path.join(PathUtils.getProjectRoot(), 'uploads', module, type, filename);
            }

            // Check if file exists
            if (!await fs.pathExists(filePath)) {
                throw new BadRequestException('File not found');
            }

            // Set appropriate headers
            const ext = path.extname(filename).toLowerCase();
            let contentType = 'application/octet-stream';

            switch (ext) {
                case '.webp':
                    contentType = 'image/webp';
                    break;
                case '.jpg':
                case '.jpeg':
                    contentType = 'image/jpeg';
                    break;
                case '.png':
                    contentType = 'image/png';
                    break;
                case '.gif':
                    contentType = 'image/gif';
                    break;
                case '.mp4':
                    contentType = 'video/mp4';
                    break;
                case '.webm':
                    contentType = 'video/webm';
                    break;
                case '.pdf':
                    contentType = 'application/pdf';
                    break;
            }

            res.setHeader('Content-Type', contentType);
            res.setHeader('Cache-Control', 'public, max-age=31536000'); // Cache for 1 year

            return res.sendFile(filePath);
        } catch (error) {
            console.error('Error serving file:', error);
            throw new BadRequestException('Error serving file');
        }
    }
}
