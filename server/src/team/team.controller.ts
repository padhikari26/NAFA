/*
https://docs.nestjs.com/controllers#controllers
*/


import { Controller, Get, Post, Put, Body, Param, UploadedFiles, UseInterceptors, Req, UseGuards, Delete } from '@nestjs/common';
import { FilesInterceptor } from '@nestjs/platform-express';
import { TeamService } from './team.service';
import { TeamDocument, TeamType } from './schemas/team.schema';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CreateTeamDto } from './dto/team.dto';
import { Role } from 'src/auth/schemas/user.schema';
import { Roles } from 'src/common/decorators/roles.decorator';
import { RolesGuard } from 'src/common/guards/roles.guard';

@Controller('teams')
export class TeamController {
    constructor(private readonly teamService: TeamService) { }
    @UseGuards(JwtAuthGuard)
    @Get()
    async findAllTeams(): Promise<{ data: TeamDocument[] }> {
        return this.teamService.findAllTeams();
    }
    @UseGuards(JwtAuthGuard)
    @Get(':type')
    async getTeamByType(@Param('type') type: TeamType) {
        return this.teamService.getTeamByType(type);
    }

    @UseGuards(JwtAuthGuard, RolesGuard)
    @Roles(Role.ADMIN)
    @Post()
    @UseInterceptors(FilesInterceptor('files', 10))
    async createOrUpdateTeam(
        @Body() teamDto: CreateTeamDto,
        @UploadedFiles() files: Express.Multer.File[],
        @Req() req: any
    ) {
        return this.teamService.createTeam(teamDto, files, req);
    }

    @UseGuards(JwtAuthGuard, RolesGuard)
    @Roles(Role.ADMIN)
    @Put(':id')
    @UseInterceptors(FilesInterceptor('files', 10))
    async updateTeam(
        @Param('id') id: string,
        @Body() teamDto: CreateTeamDto,
        @UploadedFiles() files: Express.Multer.File[],
        @Req() req: any
    ) {
        return this.teamService.updateTeam(id, teamDto, files, req);
    }

    @UseGuards(JwtAuthGuard, RolesGuard)
    @Roles(Role.ADMIN)
    @Delete(':id')
    async deleteTeam(@Param('id') id: string) {
        return this.teamService.deleteTeam(id);
    }
}
