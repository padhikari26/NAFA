
import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Gallery, GalleryDocument } from './schemas/gallery.schema';
import { GalleryDto } from './dto/gallery.dto';
import { GalleryFilterDto } from './dto/gallery-filter.dto';
import { UploadService } from '../common/services/main-upload.service';
import { UploadModule } from '../common/interfaces/upload.interface';
import { UploadOptions } from '../common/interfaces/upload.interface';
import { paginateAndFilter } from '../common/utils/paginate.utils';
import { NotificationService } from '../notification/notification.service';

@Injectable()
export class GalleryService {
    constructor(
        @InjectModel(Gallery.name) private galleryModel: Model<Gallery>,
        private readonly uploadService: UploadService,
        private readonly notificationService: NotificationService
    ) { }

    async findAll(filters: GalleryFilterDto, headers: any): Promise<any> {
        const channelPlatform = headers?.ChannelPlatform || headers?.channelplatform;
        const result = await paginateAndFilter<Gallery>(
            this.galleryModel,
            filters,
            ['title'],
        );
        let populatedData: any;
        if (channelPlatform === 'mobileapp') {
            populatedData = await Promise.all(result.data.map(async (gallery: any) => {
                let mediaObj = {};
                if (Array.isArray(gallery.medias) && gallery.medias.length > 0) {
                    const media = await this.galleryModel.db.model('UploadedFile').findById(gallery.medias[0])
                        .select('id mimetype path type uploadedFrom')
                        .lean();
                    if (media) mediaObj = media;
                }
                return {
                    _id: gallery._id,
                    title: gallery.title,
                    medias: mediaObj,
                    createdAt: gallery.createdAt,
                    updatedAt: gallery.updatedAt,
                };
            }));
            return {
                ...result,
                data: populatedData
            };
        } else {
            populatedData = await this.galleryModel.populate(result.data, {
                path: 'medias',
                model: 'UploadedFile',
                select: 'id mimetype path type uploadedFrom',
                match: { _id: { $ne: null } }
            });
            return {
                ...result,
                data: populatedData
            };
        }
    }

    async createGallery(galleryDto: GalleryDto, files: Express.Multer.File[], req: any): Promise<GalleryDocument> {
        let mediaIds: string[] = [];
        let uploadResult: any;
        let savedGallery: GalleryDocument;
        try {
            if (files && files.length > 0) {
                const options: UploadOptions = {
                    path: 'gallery',
                    type: 'photo-video',
                    multiple: true,
                    formField: 'files',
                };
                uploadResult = await this.uploadService.uploadFiles(files, options);
                if (!uploadResult.success) {
                    const errorMessages = uploadResult.errors.map(err => `${err.filename}: ${err.error}`).join(', ');
                    throw new BadRequestException(`File upload failed: ${errorMessages}`);
                }
                for (const file of uploadResult.files) {
                    if (file.type === 'image' || file.type === 'video') {
                        mediaIds.push(file.id);
                    }
                }
            }
            const newGallery = new this.galleryModel({
                ...galleryDto,
                medias: mediaIds,
            });
            savedGallery = await newGallery.save();
            return savedGallery;
        } catch (error) {
            if (uploadResult) {
                await this.uploadService.cleanupUploadedFiles(uploadResult);
            }
            throw error;
        } finally {
            setImmediate(async () => {
                try {
                    let message: any;
                    if (savedGallery.medias && savedGallery.medias.length > 0) {
                        let thumbnailPath = "";
                        const firstMedia = await this.galleryModel.db.model('UploadedFile').findById(savedGallery.medias[0])
                            .select('path')
                            .lean();
                        thumbnailPath = (firstMedia as any)?.path || "";

                        message = {
                            notification: {
                                title: `New album added: ${galleryDto.title}`,
                                body: `A new gallery "${galleryDto.title}" has been created. Check it out!`
                            },
                            data: {
                                type: "gallery",
                                id: (savedGallery._id as string | import('mongoose').Types.ObjectId).toString(),
                                thumbnail: thumbnailPath,
                                title: galleryDto.title
                            },
                            topic: 'all'
                        };
                    }
                    await this.notificationService.sendNotificationToTopic('all', message as any);
                } catch (err) {
                    console.error('Notification error:', err);
                }
            });
        }
    }

    async updateGallery(id: string, galleryDto: GalleryDto, files: Express.Multer.File[], req: any): Promise<Gallery> {
        const existingGallery = await this.galleryModel.findById(id).exec();
        if (!existingGallery) throw new BadRequestException(`Gallery with ID '${id}' not found.`);
        let finalMediaIds = existingGallery.medias.map(id => id.toString());
        // Delete files if requested
        if (galleryDto.deleteIds && galleryDto.deleteIds.length > 0) {
            const deleteResult = await this.uploadService.deleteFiles(galleryDto.deleteIds);
            finalMediaIds = finalMediaIds.filter(id => !galleryDto.deleteIds!.includes(id));
        }
        // Upload new files if provided
        if (files && files.length > 0) {
            const options: UploadOptions = {
                path: 'gallery',
                type: 'all',
                multiple: true,
                formField: 'files',
            };
            const uploadResult = await this.uploadService.uploadFiles(files, options);
            if (!uploadResult.success) {
                const errorMessages = uploadResult.errors.map(err => `${err.filename}: ${err.error}`).join(', ');
                throw new BadRequestException(`File upload failed: ${errorMessages}`);
            }
            for (const file of uploadResult.files) {
                if (file.type === 'image' || file.type === 'video') {
                    finalMediaIds.push(file.id);
                }
            }
        }
        const updatedGallery = await this.galleryModel.findByIdAndUpdate(
            id,
            { ...galleryDto, medias: finalMediaIds },
            { new: true }
        ).populate({
            path: 'medias',
            model: 'UploadedFile',
            select: 'id mimetype path type uploadedFrom',
            match: { _id: { $ne: null } }
        }).exec();
        if (!updatedGallery) throw new BadRequestException('Failed to update gallery');
        return updatedGallery;
    }

    async getGalleryById(id: string): Promise<Gallery> {
        const gallery = await this.galleryModel.findById(id).populate({
            path: 'medias',
            model: 'UploadedFile',
            select: 'id mimetype path type uploadedFrom',
            match: { _id: { $ne: null } }
        }).exec();
        if (!gallery) throw new BadRequestException(`Gallery with ID '${id}' not found.`);
        return gallery;
    }

    async deleteGallery(id: string): Promise<any> {
        const gallery = await this.galleryModel.findById(id).exec();
        if (!gallery) throw new BadRequestException(`Gallery with ID '${id}' not found.`);
        const allFileIds = [...gallery.medias].map(id => id.toString());
        if (allFileIds.length > 0) {
            await this.uploadService.deleteFiles(allFileIds);
        }
        await this.galleryModel.findByIdAndDelete(id).exec();
        return { status: 'success', message: 'Gallery deleted successfully' };
    }
}
