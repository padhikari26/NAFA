import { IsString, IsNotEmpty, IsArray, IsOptional } from "class-validator";

export class GalleryDto {
    @IsString()
    @IsNotEmpty()
    title: string;

    @IsArray()
    @IsString({ each: true })
    @IsOptional()
    deleteIds?: string[];
}
