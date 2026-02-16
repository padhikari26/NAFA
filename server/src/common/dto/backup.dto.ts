import { IsOptional, IsBoolean, IsArray, IsString } from 'class-validator';

export class BackupOptionsDto {
    @IsOptional()
    @IsBoolean()
    includeIndexes?: boolean;

    @IsOptional()
    @IsArray()
    @IsString({ each: true })
    skipCollections?: string[];

    @IsOptional()
    @IsArray()
    @IsString({ each: true })
    onlyCollections?: string[];

    @IsOptional()
    @IsBoolean()
    compress?: boolean;
}

export class RestoreOptionsDto {
    @IsOptional()
    @IsBoolean()
    overwriteExisting?: boolean;

    @IsOptional()
    @IsArray()
    @IsString({ each: true })
    skipCollections?: string[];

    @IsOptional()
    @IsArray()
    @IsString({ each: true })
    onlyCollections?: string[];

    @IsOptional()
    @IsBoolean()
    validateBeforeRestore?: boolean;
}