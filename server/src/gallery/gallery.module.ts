import { Module } from '@nestjs/common';
import { GalleryController } from './gallery.controller';
import { GalleryService } from './gallery.service';
import { MongooseModule } from '@nestjs/mongoose';
import { Gallery, GallerySchema } from './schemas/gallery.schema';
import { uploadModule } from '../common/modules/professional-upload.module';
import { FirebaseService } from '../firebase/firebase.service';
import { NotificationService } from '../notification/notification.service';
import { Notifications, NotificationSchema } from '../notification/schemas/notification.schema';

@Module({
    imports: [
        MongooseModule.forFeature([
            { name: Gallery.name, schema: GallerySchema },
            { name: Notifications.name, schema: NotificationSchema }
        ]),
        uploadModule,
    ],
    controllers: [GalleryController],
    providers: [GalleryService, NotificationService,
        FirebaseService],
})
export class GalleryModule { }
