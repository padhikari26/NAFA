import { IsString, IsNotEmpty, IsDateString, IsArray, IsOptional } from 'class-validator';

export class CreateEventDto {
    @IsString()
    @IsNotEmpty()
    title: string;

    @IsString()
    @IsNotEmpty()
    description: string;

    @IsDateString()
    @IsNotEmpty()
    date: string;

    @IsArray()
    @IsString({ each: true })
    @IsOptional()
    deleteIds?: string[];
}