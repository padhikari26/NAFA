
import { IsOptional, IsString, IsIn, IsNumberString, IsBoolean } from 'class-validator';
import { Transform } from 'class-transformer';

export class FilterDto {
    @IsOptional()
    @Transform(({ value }) => parseInt(value, 10))
    page?: number;

    @IsOptional()
    @Transform(({ value }) => parseInt(value, 10))
    limit?: number;

    @IsOptional()
    @IsString()
    search?: string;

    @IsOptional()
    @IsString()
    sort?: string;

    @IsOptional()
    @IsIn(['asc', 'desc'])
    order?: 'asc' | 'desc';

    @IsOptional()
    @IsString()
    date?: string;
}
