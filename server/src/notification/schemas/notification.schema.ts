import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type NotificationDocument = Notifications & Document;



@Schema({
    timestamps: true,
})
export class Notifications {

    @Prop({ required: true })
    title: string;

    @Prop({ required: true })
    body: string;

    @Prop({ type: Object, default: {} })
    data: Record<string, any>;
}

export const NotificationSchema = SchemaFactory.createForClass(Notifications);