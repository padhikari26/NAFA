import { IsString, IsOptional, IsObject, IsNotEmpty } from 'class-validator';

export class SendNotificationToAllDto {
    @IsNotEmpty()
    @IsString()
    title: string;

    @IsNotEmpty()
    @IsString()
    body: string;

    @IsOptional()
    @IsObject()
    data?: any;
}

export class SendNotificationToTokensDto {
    @IsNotEmpty()
    @IsString({ each: true })
    tokens: string[];

    @IsNotEmpty()
    @IsString()
    title: string;

    @IsNotEmpty()
    @IsString()
    body: string;

    @IsOptional()
    @IsObject()
    data?: any;
}