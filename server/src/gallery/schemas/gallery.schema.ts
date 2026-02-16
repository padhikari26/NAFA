
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Schema as MongooseSchema } from 'mongoose';
export type GalleryDocument = Gallery & Document;
@Schema({ timestamps: true })
export class Gallery {
    @Prop({ required: true })
    title: string;

    @Prop({ type: [MongooseSchema.Types.ObjectId], ref: 'UploadedFile', default: [] })
    medias: MongooseSchema.Types.ObjectId[];
}

export const GallerySchema = SchemaFactory.createForClass(Gallery);
