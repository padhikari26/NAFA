/*
https://docs.nestjs.com/controllers#controllers
*/

import { Controller, Delete, Get, Put, Req, UseGuards, UploadedFiles, UseInterceptors, BadRequestException, Param } from '@nestjs/common';
import { Post, Body } from '@nestjs/common';
import { FilesInterceptor } from '@nestjs/platform-express';
import { EventsService } from './events.service';
import { CreateEventDto } from './dto/events.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { Roles } from '../common/decorators/roles.decorator';
import { Role } from '../auth/schemas/user.schema';
import { EventsFilterDto } from './dto/events-filter.dto';
import { CreateBannerDto } from './dto/banner.dto';
import { isValidObjectId } from 'mongoose';

@Controller('events')
export class EventsController {
    constructor(
        private readonly eventsService: EventsService,
    ) { }
    @UseGuards(JwtAuthGuard)
    @Get('featured')
    async getFeaturedEvents() {
        return this.eventsService.findFeaturedEvents();
    }

    @UseGuards(JwtAuthGuard)
    @Post('all')
    async getEvents(@Body() filters: EventsFilterDto, @Req() req: any) {
        return this.eventsService.findAll(filters, req.headers);
    }

    @UseGuards(JwtAuthGuard)
    @Roles(Role.ADMIN)
    @Post('reminder')
    //remind event send notification
    async remindEvent(@Body('eventId') eventId: string) {
        return this.eventsService.remindEvent(eventId);
    }

    @UseGuards(JwtAuthGuard)
    @Roles(Role.ADMIN)
    @Post('create')
    @UseInterceptors(FilesInterceptor('files', 20))
    async createEvent(
        @Body() eventData: CreateEventDto,
        @UploadedFiles() files: Express.Multer.File[],
        @Req() req: any
    ) {
        return this.eventsService.createEvent(eventData, files || [], req);
    }

    @UseGuards(JwtAuthGuard)
    @Roles(Role.ADMIN)
    @Put('update/:id')
    @UseInterceptors(FilesInterceptor('files', 20))
    async updateEvent(
        @Param('id') id: string,
        @Body() eventData: CreateEventDto,
        @UploadedFiles() files: Express.Multer.File[],
        @Req() req: any
    ) {
        return this.eventsService.updateEvent(id, eventData, files || [], req);
    }

    @UseGuards(JwtAuthGuard)
    @Get(':id')
    async getEvent(@Param('id') id: string) {
        return this.eventsService.getEventById(id);
    }

    @UseGuards(JwtAuthGuard)
    @Roles(Role.ADMIN)
    @Delete(':id')
    async deleteEvent(@Param('id') id: string) {
        return this.eventsService.deleteEvent(id);
    }

    @UseGuards(JwtAuthGuard)
    @Get('banner/popup')
    async getBanner(@Req() req: any) {
        return this.eventsService.getBanner(req.headers);
    }

    @UseGuards(JwtAuthGuard)
    @Roles(Role.ADMIN)
    @Post('banner/create')
    @UseInterceptors(FilesInterceptor('files', 1))
    async createBanner(@UploadedFiles() files: Express.Multer.File[], @Body() bannerData: CreateBannerDto) {
        return this.eventsService.createBanner(files, bannerData);
    }

    @UseGuards(JwtAuthGuard)
    @Roles(Role.ADMIN)
    @Put('banner/:id')
    @UseInterceptors(FilesInterceptor('files', 1))
    async updateBanner(@Param('id') id: string, @UploadedFiles() files: Express.Multer.File[], @Body() bannerData: CreateBannerDto) {
        if (!isValidObjectId(id)) throw new BadRequestException('Invalid banner id');
        return this.eventsService.updateBanner(id, files, bannerData);
    }

    @UseGuards(JwtAuthGuard)
    @Roles(Role.ADMIN)
    @Delete('banner/:id')
    async deleteBanner(@Param('id') id: string) {
        if (!isValidObjectId(id)) throw new BadRequestException('Invalid banner id');
        return this.eventsService.deleteBanner(id);
    }
}
