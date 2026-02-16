export interface UploadConfig {
    maxFileSize: {
        image: number;
        video: number;
        document: number;
    };
    allowedMimeTypes: {
        images: string[];
        videos: string[];
        documents: string[];
    };
    storage: {
        basePath: string;
        tempPath: string;
    };
    processing: {
        imageQuality: number;
        thumbnailSize: number;
        enableCompression: boolean;
    };
    security: {
        enableVirusScanning: boolean;
        maxFilesPerRequest: number;
        allowedFileExtensions: string[];
    };
}

export const uploadConfig: UploadConfig = {
    maxFileSize: {
        image: 10 * 1024 * 1024, // 10MB
        video: 100 * 1024 * 1024, // 100MB
        document: 50 * 1024 * 1024, // 50MB
    },
    allowedMimeTypes: {
        images: ['image/jpeg', 'image/jpg', 'image/png', 'image/webp', 'image/gif'],
        videos: ['video/mp4', 'video/webm', 'video/ogg', 'video/avi', 'video/mov'],
        documents: ['application/pdf'],
    },
    storage: {
        basePath: process.env.UPLOAD_BASE_PATH || 'uploads',
        tempPath: process.env.UPLOAD_TEMP_PATH || 'uploads/temp',
    },
    processing: {
        imageQuality: 85,
        thumbnailSize: 300,
        enableCompression: true,
    },
    security: {
        enableVirusScanning: false, // Would integrate with ClamAV in production
        maxFilesPerRequest: 50,
        allowedFileExtensions: ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.mp4', '.webm', '.pdf'],
    },
};
