export interface BackupMetadata {
    collectionName: string;
    backupDate: Date;
    documentCount: number;
    fileSize: number;
    backupVersion: string;
    databaseName: string;
}

export interface CollectionBackupInfo {
    name: string;
    documentCount: number;
    indexes: any[];
    options: any;
}

export interface DatabaseBackupResult {
    success: boolean;
    backupPath: string;
    collections: CollectionBackupInfo[];
    totalDocuments: number;
    backupDate: Date;
    errors?: string[];
}

export interface RestoreResult {
    success: boolean;
    restoredCollections: string[];
    totalDocumentsRestored: number;
    restoreDate: Date;
    errors?: string[];
    warnings?: string[];
}

export interface BackupFileInfo {
    filename: string;
    collectionName: string;
    metadata: BackupMetadata;
    filePath: string;
    exists: boolean;
}

export interface RestoreOptions {
    overwriteExisting?: boolean;
    skipCollections?: string[];
    onlyCollections?: string[];
    validateBeforeRestore?: boolean;
}

export interface BackupOptions {
    includeIndexes?: boolean;
    skipCollections?: string[];
    onlyCollections?: string[];
    compress?: boolean;
}