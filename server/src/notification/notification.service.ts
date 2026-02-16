// notification.service.ts
import { Injectable } from '@nestjs/common';
import { FirebaseService } from 'src/firebase/firebase.service';
import * as admin from 'firebase-admin';
import { paginateAndFilter } from 'src/common/utils/paginate.utils';
import { NotificationDocument, Notifications } from './schemas/notification.schema';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { FilterDto } from 'src/common/dto/filter.dto';

@Injectable()
export class NotificationService {
    constructor(private readonly firebaseService: FirebaseService,
        @InjectModel(Notifications.name) private notificationModel: Model<NotificationDocument>,
    ) { }

    async findAll(filters: FilterDto): Promise<any> {
        const result = await paginateAndFilter<NotificationDocument>(
            this.notificationModel,
            filters,
            ['title', 'body'],

        );
        return result
    }

    async sendNotificationToTopic(topic: string, message: admin.messaging.Message) {
        try {
            const response = await this.firebaseService.sendNotificationToTopic(topic, message);
            const { title, body } = message.notification || {};
            if (!title || !body) {
                throw new Error('Notification title and body are required');
            }
            const notification = new this.notificationModel({
                title,
                body,
                data: message.data || {},
            });
            await notification.save();
            return response;
        } catch (error) {
            console.error('Error sending notification to topic:', error);
            throw new Error('Failed to send notification to topic');
        } finally {
            const threeMonthsAgo = new Date();
            threeMonthsAgo.setMonth(threeMonthsAgo.getMonth() - 3);
            await this.notificationModel.deleteMany({ createdAt: { $lt: threeMonthsAgo } });
        }
    }

    //delete
    async deleteNotification(id: string) {
        return this.notificationModel.findByIdAndDelete(id);
    }

}
