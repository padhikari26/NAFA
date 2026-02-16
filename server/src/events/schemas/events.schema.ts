import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';
import { Schema as MongooseSchema } from 'mongoose';

export type EventDocument = Event & Document;

@Schema({
    timestamps: true,
})
export class Event {
    @Prop({ required: true })
    title: string;

    @Prop({ required: true })
    description: string;

    @Prop({ required: true })
    date: Date;

    @Prop({ type: [MongooseSchema.Types.ObjectId], ref: 'UploadedFile', default: [] })
    media: MongooseSchema.Types.ObjectId[];

    @Prop({ type: [MongooseSchema.Types.ObjectId], ref: 'UploadedFile', default: [] })
    documents: MongooseSchema.Types.ObjectId[];
}

export const EventSchema = SchemaFactory.createForClass(Event);