import * as path from 'path';

/**
 * Utility for consistent path resolution across the application.
 * This ensures uploads folder is always created relative to the project root,
 * regardless of the current working directory when the app is deployed.
 */
export class PathUtils {
    /**
     * Get the project root directory.
     * In development: resolves to the project folder
     * In production: resolves relative to the compiled dist folder
     */
    static getProjectRoot(): string {
        // When compiled to dist, __dirname will be in dist/common/utils
        // We need to go up to the project root
        return path.resolve(__dirname, '../../../../');
    }

    /**
     * Get the uploads directory path
     */
    static getUploadsPath(): string {
        return path.join(this.getProjectRoot(), 'uploads');
    }

    /**
     * Get path for a specific upload module
     */
    static getModulePath(module: string): string {
        return path.join(this.getUploadsPath(), module);
    }

    /**
     * Convert absolute path to relative path from project root
     */
    static getRelativePath(absolutePath: string): string {
        const projectRoot = this.getProjectRoot();
        return path.relative(projectRoot, absolutePath).replace(/\\/g, '/');
    }

    /**
     * Get temp directory path
     */
    static getTempPath(): string {
        return path.join(this.getUploadsPath(), 'temp');
    }
}