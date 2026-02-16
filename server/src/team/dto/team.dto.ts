import { IsString, IsNotEmpty, IsDateString, IsArray, IsOptional } from 'class-validator';
import { TeamType } from '../schemas/team.schema';

export class CreateTeamDto {

    @IsString()
    @IsNotEmpty()
    type: TeamType;

    @IsString()
    @IsNotEmpty()
    content: string;

    @IsArray()
    @IsString({ each: true })
    @IsOptional()
    deleteIds?: string[];
}