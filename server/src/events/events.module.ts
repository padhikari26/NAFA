import { EventsService } from './events.service';
import { EventsController } from './events.controller';
/*
https://docs.nestjs.com/modules
*/

import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { User, UserSchema } from '../auth/schemas/user.schema';
import { Event, EventSchema } from './schemas/events.schema';
import { uploadModule } from '../common/modules/professional-upload.module';
import { NotificationService } from '../notification/notification.service';
import { FirebaseService } from '../firebase/firebase.service';
import { Notifications, NotificationSchema } from '../notification/schemas/notification.schema';
import { Banner, BannerSchema } from './schemas/banner.schema';

@Module({
    imports: [
        MongooseModule.forFeature([
            { name: User.name, schema: UserSchema },
            { name: Event.name, schema: EventSchema },
            { name: Notifications.name, schema: NotificationSchema },
            { name: Banner.name, schema: BannerSchema }
        ]),
        uploadModule,
    ],
    controllers: [
        EventsController,
    ],
    providers: [
        EventsService,
        NotificationService,
        FirebaseService
    ],
})
export class EventsModule { }
