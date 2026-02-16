import { IsString, IsNotEmpty, IsDateString, IsArray, IsOptional } from 'class-validator';

export class CreateBannerDto {

    @IsDateString()
    @IsNotEmpty()
    startDate: string;

    @IsDateString()
    @IsNotEmpty()
    endDate: string;

    @IsString()
    @IsOptional()
    deleteId?: string;
}