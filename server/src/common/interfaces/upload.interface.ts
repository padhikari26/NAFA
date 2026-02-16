export type UploadOptions = {
    path: string; // e.g., 'events', 'gallery', 'members'
    type: 'photo' | 'video' | 'document' | 'all' | 'photo-video';
    multiple?: boolean;
    formField?: string; // e.g., 'files', 'photo', 'document'
    maxFileNumber?: number; // in bytes
};
export enum FileType {
    IMAGE = 'image',
    VIDEO = 'video',
    DOCUMENT = 'document',
}

export enum UploadModule {
    EVENTS = 'events',
    BLOGS = 'blogs',
    MEMBERS = 'members',
    NOTIFICATIONS = 'notifications',
    GALLERY = 'gallery',
    TEAMS = 'teams',
    BANNER = 'banner'
}

export interface ProcessedFile {
    id: string;
    originalName: string;
    filename: string;
    path: string;
    size: number;
    mimetype: string;
    type: FileType;
    module: UploadModule;
    compressed?: boolean;
    thumbnailPath?: string;
    metadata?: Record<string, any>;
}

export interface UploadResult {
    success: boolean;
    files: ProcessedFile[];
    errors: UploadError[];
    totalSize: number;
    processingTime: number;
}

export interface UploadError {
    filename: string;
    error: string;
    code: string;
}

export interface FileValidationResult {
    isValid: boolean;
    errors: string[];
    fileType: FileType | null;
}
