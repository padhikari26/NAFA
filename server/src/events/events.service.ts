import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { User, UserDocument } from '../auth/schemas/user.schema';
import { Event, EventDocument } from './schemas/events.schema';
import { CreateEventDto } from './dto/events.dto';
import { paginateAndFilter } from '../common/utils/paginate.utils';
import { EventsFilterDto } from './dto/events-filter.dto';
import { UploadService } from '../common/services/main-upload.service';
import { UploadOptions } from '../common/interfaces/upload.interface';
import { NotificationService } from 'src/notification/notification.service';
import { Banner, BannerDocument } from './schemas/banner.schema';
import { CreateBannerDto } from './dto/banner.dto';

@Injectable()
export class EventsService {
    constructor(
        @InjectModel(User.name) private userModel: Model<UserDocument>,
        @InjectModel(Event.name) private eventModel: Model<EventDocument>,
        @InjectModel(Banner.name) private bannerModel: Model<BannerDocument>,
        private readonly uploadService: UploadService,
        private readonly notificationService: NotificationService
    ) { }

    async findAll(filters: EventsFilterDto, headers: any): Promise<any> {
        const dateFilter = filters.isUpcoming === undefined || filters.isUpcoming === null
            ? {}
            : (filters.isUpcoming
                ? { date: { $gte: new Date() } }
                : { date: { $lt: new Date() } });

        let sortField: string;
        let sortOrder: string;

        if (filters.isUpcoming === undefined || filters.isUpcoming === null) {
            sortField = 'createdAt';
            sortOrder = 'desc';
        } else if (filters.isUpcoming) {
            sortField = 'date';
            sortOrder = 'asc';
        } else {
            sortField = 'date';
            sortOrder = 'desc';
        }

        const eventsFilters = {
            ...filters,
            sort: sortField,
            order: sortOrder
        };

        const result = await paginateAndFilter<EventDocument>(
            this.eventModel,
            eventsFilters,
            ['title'],
            dateFilter,
            ['date']
        );

        const channelPlatform = headers?.ChannelPlatform || headers?.channelplatform;

        let populatedData: any;
        if (channelPlatform === 'mobileapp') {
            populatedData = await Promise.all(result.data.map(async (event: any) => {
                let mediaObj = {};
                if (Array.isArray(event.media) && event.media.length > 0) {
                    const media = await this.eventModel.db.model('UploadedFile').findById(event.media[0])
                        .select('id mimetype path type uploadedFrom')
                        .lean();
                    if (media) mediaObj = media;
                }
                return {
                    _id: event._id,
                    title: event.title,
                    date: event.date,
                    media: mediaObj,
                    createdAt: event.createdAt,
                    updatedAt: event.updatedAt,
                };
            }));
            return {
                ...result,
                data: populatedData
            };
        } else {
            populatedData = await this.eventModel.populate(result.data, [
                {
                    path: 'media',
                    model: 'UploadedFile',
                    select: 'id mimetype path type uploadedFrom',
                    match: { _id: { $ne: null, $type: 'objectId' } }
                },
                {
                    path: 'documents',
                    model: 'UploadedFile',
                    select: 'id mimetype path type uploadedFrom',
                    match: { _id: { $ne: null, $type: 'objectId' } }
                }
            ]);
            return {
                ...result,
                data: populatedData
            };
        }
    }

    async createEvent(eventDto: CreateEventDto, files: Express.Multer.File[], req: any): Promise<EventDocument> {
        let mediaIds: string[] = [];
        let documentIds: string[] = [];

        let uploadResult: any;
        let savedEvent: EventDocument;
        try {
            if (files && files.length > 0) {
                const options: UploadOptions = {
                    path: 'events',
                    type: 'all',
                    multiple: true,
                    formField: 'files',
                };
                uploadResult = await this.uploadService.uploadFiles(files, options);

                // Check if upload failed
                if (!uploadResult.success) {
                    const errorMessages = uploadResult.errors.map(err => `${err.filename}: ${err.error}`).join(', ');
                    throw new BadRequestException(`File upload failed: ${errorMessages}`);
                }

                for (const file of uploadResult.files) {
                    if (file.type === 'image' || file.type === 'video') {
                        mediaIds.push(file.id);
                    } else if (file.type === 'document') {
                        documentIds.push(file.id);
                    }
                }
            }

            const newEvent = new this.eventModel({
                ...eventDto,
                media: mediaIds,
                documents: documentIds,
            });
            console.log(newEvent);
            savedEvent = await newEvent.save();

            return savedEvent;
        } catch (error) {
            // If error after upload, clean up orphaned files
            if (uploadResult) {
                await this.uploadService.cleanupUploadedFiles(uploadResult);
            }
            throw error;
        } finally {
            setImmediate(async () => {
                try {

                    const eventDate = eventDto.date ? new Date(eventDto.date) : new Date();
                    const formattedDate = eventDate.toLocaleDateString('en-US', {
                        day: '2-digit',
                        month: 'long',
                        year: 'numeric'
                    });

                    let thumbnailPath = "";
                    if (savedEvent.media && savedEvent.media.length > 0) {
                        const firstMedia = await this.eventModel.db.model('UploadedFile').findById(savedEvent.media[0])
                            .select('path')
                            .lean();
                        thumbnailPath = (firstMedia as any)?.path || "";
                    }

                    const message = {
                        notification: {
                            title: `New Event: ${eventDto.title}`,
                            body: `A new event "${eventDto.title}" is scheduled for ${formattedDate}. Don't miss it!`
                        },
                        data: {
                            type: "event",
                            id: (savedEvent._id as string | import('mongoose').Types.ObjectId).toString(),
                            thumbnail: thumbnailPath,
                            title: eventDto.title
                        },
                    };
                    await this.notificationService.sendNotificationToTopic('all', message as any);
                } catch (err) {
                    console.error('Notification error:', err);
                }
            });
        }


    }

    async updateEvent(
        id: string,
        eventDto: CreateEventDto & { deleteIds?: string[] },
        files: Express.Multer.File[],
        req: any
    ): Promise<{ message: string; event: EventDocument }> {
        const existingEvent = await this.eventModel.findById(id).exec();
        if (!existingEvent) {
            throw new BadRequestException(`Event with ID '${id}' not found.`);
        }

        // Handle file updates using the new UploadService
        let finalMediaIds = existingEvent.media.map(id => id.toString());
        let finalDocumentIds = existingEvent.documents.map(id => id.toString());

        // Upload new files if provided
        if (files && files.length > 0) {
            const options: UploadOptions = {
                path: 'events',
                type: 'all',
                multiple: true,
                formField: 'files',
            };
            const uploadResult = await this.uploadService.uploadFiles(files, options);

            // Check if upload failed
            if (!uploadResult.success) {
                const errorMessages = uploadResult.errors.map(err => `${err.filename}: ${err.error}`).join(', ');
                throw new BadRequestException(`File upload failed: ${errorMessages}`);
            }

            for (const file of uploadResult.files) {
                if (file.type === 'image' || file.type === 'video') {
                    finalMediaIds.push(file.id);
                } else if (file.type === 'document') {
                    finalDocumentIds.push(file.id);
                }
            }
        }
        // Delete files if requested
        if (eventDto.deleteIds && eventDto.deleteIds.length > 0) {
            const deleteResult = await this.uploadService.deleteFiles(eventDto.deleteIds);
            finalMediaIds = finalMediaIds.filter(id => !eventDto.deleteIds!.includes(id));
            finalDocumentIds = finalDocumentIds.filter(id => !eventDto.deleteIds!.includes(id));
        }

        const finalFiles = { media: finalMediaIds, documents: finalDocumentIds };

        const updatedEvent = await this.eventModel
            .findByIdAndUpdate(
                id,
                {
                    ...eventDto,
                    media: finalFiles.media,
                    documents: finalFiles.documents,
                },
                { new: true },
            )
            .populate([
                {
                    path: 'media',
                    model: 'UploadedFile',
                    select: 'id mimetype path type uploadedFrom',
                    match: { _id: { $ne: null, $type: 'objectId' } }
                },
                {
                    path: 'documents',
                    model: 'UploadedFile',
                    select: 'id mimetype path type uploadedFrom',
                    match: { _id: { $ne: null, $type: 'objectId' } }
                }
            ])
            .exec();

        if (!updatedEvent) {
            throw new BadRequestException(`Failed to update event`);
        }

        const deletedCount = (eventDto.deleteIds || []).length;
        const addedCount = files ? files.length : 0;

        return {
            message: `Event updated successfully. ${deletedCount > 0 ? `Deleted ${deletedCount} files. ` : ''}Added ${addedCount} new files.`,
            event: updatedEvent,
        };
    }

    async getEventById(id: string): Promise<EventDocument> {
        const event = await this.eventModel
            .findById(id)
            .populate([
                {
                    path: 'media',
                    model: 'UploadedFile',
                    select: 'id mimetype path type uploadedFrom',
                    match: { _id: { $ne: null, $type: 'objectId' } }
                },
                {
                    path: 'documents',
                    model: 'UploadedFile',
                    select: 'id mimetype path type uploadedFrom',
                    match: { _id: { $ne: null, $type: 'objectId' } }
                }
            ])
            .exec();
        if (!event) {
            throw new BadRequestException(`Event with ID '${id}' not found.`);
        }
        return event;
    }

    async deleteEvent(id: string): Promise<any> {
        const event = await this.eventModel.findById(id).exec();
        if (!event) {
            throw new BadRequestException(`Event with ID '${id}' not found.`);
        }

        // Delete associated files
        const allFileIds = [...event.media, ...event.documents].map(id => id.toString());
        if (allFileIds.length > 0) {
            await this.uploadService.deleteFiles(allFileIds);
        }

        // Delete the event
        await this.eventModel.findByIdAndDelete(id).exec();

        return {
            status: 'success',
            message: 'Event deleted successfully'
        };
    }


    async findFeaturedEvents(): Promise<any> {
        const now = new Date();
        const featuredEvent = await this.eventModel
            .findOne({
                date: { $gte: now }
            })
            .sort({ date: 1 })
            .populate([
                {
                    path: 'media',
                    model: 'UploadedFile',
                    select: 'id mimetype path type uploadedFrom',
                    match: { _id: { $ne: null, $type: 'objectId' } }
                },
                {
                    path: 'documents',
                    model: 'UploadedFile',
                    select: 'id mimetype path type uploadedFrom',
                    match: { _id: { $ne: null, $type: 'objectId' } }
                }
            ])
            .exec();

        return {
            data: featuredEvent
        };
    }

    async createBanner(files: Express.Multer.File[], bannerData: CreateBannerDto): Promise<BannerDocument> {
        if (!files || files.length === 0) throw new BadRequestException('No file provided');

        // Check if a banner already exists
        const existingBanner = await this.bannerModel.findOne({});
        if (existingBanner) {
            if (existingBanner.media) {
                await this.uploadService.deleteFiles([existingBanner.media.toString()]);
            }
            await this.bannerModel.deleteOne({ _id: existingBanner._id });
        }

        const options: UploadOptions = {
            path: 'banner',
            type: 'photo',
            multiple: false,
            formField: 'files',
        };
        const uploadResult = await this.uploadService.uploadFiles([files[0]], options);

        // Check if upload failed
        if (!uploadResult.success) {
            const errorMessages = uploadResult.errors.map(err => `${err.filename}: ${err.error}`).join(', ');
            throw new BadRequestException(`File upload failed: ${errorMessages}`);
        }

        const uploadedFile = uploadResult.files[0];
        if (!uploadedFile || !uploadedFile.id) {
            throw new BadRequestException('File upload failed or file ID missing');
        }
        const banner = new this.bannerModel({ media: new Types.ObjectId(uploadedFile.id), ...bannerData });
        return banner.save();
    }

    async updateBanner(bannerId: string, files: Express.Multer.File[], bannerData: CreateBannerDto): Promise<BannerDocument> {
        const banner = await this.bannerModel.findById(bannerId);
        if (!banner) throw new BadRequestException('Banner not found');
        let newMediaId: Types.ObjectId | undefined;
        if (files && files.length > 0) {
            const options: UploadOptions = {
                path: 'banner',
                type: 'photo',
                multiple: false,
                formField: 'files',
            };
            const uploadResult = await this.uploadService.uploadFiles([files[0]], options);

            // Check if upload failed
            if (!uploadResult.success) {
                const errorMessages = uploadResult.errors.map(err => `${err.filename}: ${err.error}`).join(', ');
                throw new BadRequestException(`File upload failed: ${errorMessages}`);
            }

            const uploadedFile = uploadResult.files[0];
            newMediaId = new Types.ObjectId(uploadedFile.id);

            if (banner.media) {
                await this.uploadService.deleteFiles([banner.media.toString()]);
            }
        }

        const updatedBanner = await this.bannerModel.findByIdAndUpdate(
            bannerId,
            {
                ...(newMediaId ? { media: newMediaId } : {}),
                ...bannerData
            },
            { new: true }
        );

        if (!updatedBanner) throw new BadRequestException('Banner not found');
        return updatedBanner;
    }



    async deleteBanner(bannerId: string): Promise<{ message: string }> {
        const banner = await this.bannerModel.findById(bannerId);
        if (!banner) throw new BadRequestException('Banner not found');
        if (banner.media) {
            await this.uploadService.deleteFiles([banner.media.toString()]);
        }
        await this.bannerModel.deleteOne({ _id: bannerId });

        return {
            message: 'Banner deleted successfully'
        };
    }

    async getBanner(headers: any): Promise<{ data: BannerDocument | null }> {
        const now = new Date();
        const channelPlatform = headers?.ChannelPlatform || headers?.channelplatform;
        if (channelPlatform === "mobileapp") {
            const banner = await this.bannerModel.findOne({
                startDate: { $lte: now },
                endDate: { $gte: now }
            }).populate({
                path: 'media',
                model: 'UploadedFile',
                select: 'id mimetype path type uploadedFrom',
                match: { _id: { $ne: null, $type: 'objectId' } }
            }).exec();
            return {
                data: banner
            }
        } else {
            const banner = await this.bannerModel.findOne().populate({
                path: 'media',
                model: 'UploadedFile',
                select: 'id mimetype path type uploadedFrom',
                match: { _id: { $ne: null, $type: 'objectId' } }
            }).exec();
            return {
                data: banner
            };
        }
    }

    //remind event
    async remindEvent(eventId: string): Promise<{ message: string }> {
        try {
            const event = await this.eventModel.findById(eventId)
                .populate({
                    path: 'media',
                    model: 'UploadedFile',
                    select: 'id mimetype path type uploadedFrom',
                    match: { _id: { $ne: null, $type: 'objectId' } }
                })
                .exec();
            if (!event) {
                throw new BadRequestException(`Event with ID '${eventId}' not found.`);
            }
            const eventDate = event.date ? new Date(event.date) : new Date();
            const formattedDate = eventDate.toLocaleDateString('en-US', {
                day: '2-digit',
                month: 'long',
                year: 'numeric'
            });

            let thumbnailPath = "";
            if (event.media && event.media.length > 0) {
                const firstMedia = event.media[0] as any;
                thumbnailPath = firstMedia?.path || "";
            }

            const message = {
                notification: {
                    title: `New Event: ${event.title}`,
                    body: `A new event "${event.title}" is scheduled for ${formattedDate}. Don't miss it!`
                },
                data: {
                    type: "event",
                    id: (event._id as Types.ObjectId | string).toString(),
                    thumbnail: thumbnailPath,
                    title: event.title
                },
            };
            await this.notificationService.sendNotificationToTopic('all', message as any);
            return { message: 'Event reminder sent successfully' };
        } catch (err) {
            console.error('Notification error:', err);
            throw err;
        }
    }

}
