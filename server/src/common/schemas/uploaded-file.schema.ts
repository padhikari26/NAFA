import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type UploadedFileDocument = UploadedFile & Document;

@Schema({
    timestamps: true,
})
export class UploadedFile {
    @Prop({ required: true })
    filename: string;

    @Prop({ required: true })
    originalName: string;

    @Prop({ required: true })
    mimetype: string;

    @Prop({ required: true })
    size: number;

    @Prop({ required: true })
    path: string;

    @Prop()
    thumbnailPath?: string;

    @Prop({ required: true, enum: ['image', 'video', 'document'] })
    type: string;

    @Prop({ required: true, enum: ['events', 'blogs', 'members', 'notifications', 'gallery', 'teams', 'banner'] })
    uploadedFrom: string;

    @Prop({ default: false })
    compressed?: boolean;
}

export const UploadedFileSchema = SchemaFactory.createForClass(UploadedFile);
