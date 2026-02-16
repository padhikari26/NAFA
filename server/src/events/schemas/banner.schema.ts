import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';
import { Schema as MongooseSchema } from 'mongoose';


export type BannerDocument = Banner & Document;

@Schema({
    timestamps: true,
})
export class Banner {
    @Prop({ type: MongooseSchema.Types.ObjectId, ref: 'UploadedFile', default: null })
    media: MongooseSchema.Types.ObjectId;

    @Prop({ type: Date, required: true })
    startDate: Date;

    @Prop({ type: Date, required: true })
    endDate: Date;
}
export const BannerSchema = SchemaFactory.createForClass(Banner);