
import {
    Controller,
    Get,
    Post,
    Put,
    Delete,
    Body,
    Param,
    Req,
    UploadedFiles,
    UseInterceptors,
    BadRequestException,
    Query,
    UseGuards
} from '@nestjs/common';
import { FilesInterceptor } from '@nestjs/platform-express';
import { GalleryService } from './gallery.service';
import { GalleryDto } from './dto/gallery.dto';
import { GalleryFilterDto } from './dto/gallery-filter.dto';
import { JwtAuthGuard } from 'src/auth/guards/jwt-auth.guard';
import { Role } from 'src/auth/schemas/user.schema';
import { Roles } from 'src/common/decorators/roles.decorator';
import { RolesGuard } from 'src/common/guards/roles.guard';
import { Public } from 'src/common/decorators/public.decorator';

@Controller('gallery')
export class GalleryController {
    constructor(private readonly galleryService: GalleryService) { }
    @UseGuards(JwtAuthGuard)
    @Post('all')
    async getGalleries(@Body() filters: GalleryFilterDto, @Req() req: any) {
        return this.galleryService.findAll(filters, req.headers);
    }
    @UseGuards(JwtAuthGuard, RolesGuard)
    @Roles(Role.ADMIN)
    @Post('create')
    @UseInterceptors(FilesInterceptor('files', 20))
    async createGallery(
        @Body() galleryData: GalleryDto,
        @UploadedFiles() files: Express.Multer.File[],
        @Req() req: any
    ) {
        console.log('Incoming files:', files);
        console.log('Incoming req.files:', req.files);
        return this.galleryService.createGallery(galleryData, files || [], req);
    }

    @UseGuards(JwtAuthGuard, RolesGuard)
    @Roles(Role.ADMIN)
    @Put('update/:id')
    @UseInterceptors(FilesInterceptor('files', 20))
    async updateGallery(
        @Param('id') id: string,
        @Body() galleryData: GalleryDto,
        @UploadedFiles() files: Express.Multer.File[],
        @Req() req: any
    ) {
        console.log('Incoming files:', files);
        console.log('Incoming req.files:', req.files);
        return this.galleryService.updateGallery(id, galleryData, files || [], req);
    }
    @UseGuards(JwtAuthGuard)
    @Get(':id')
    async getGalleryById(@Param('id') id: string) {
        return this.galleryService.getGalleryById(id);
    }

    @UseGuards(JwtAuthGuard, RolesGuard)
    @Roles(Role.ADMIN)
    @Delete(':id')
    async deleteGallery(@Param('id') id: string) {
        return this.galleryService.deleteGallery(id);
    }
}
