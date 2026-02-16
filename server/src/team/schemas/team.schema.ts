import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';
import { Schema as MongooseSchema } from 'mongoose';

export type TeamDocument = Team & Document;

export enum TeamType {
    EXECUTIVE = 'executive',
    ADVISORY = 'advisory',
    PASTEXECUTIVE = 'pastexecutive',
}

@Schema({
    timestamps: true,
})
export class Team {

    @Prop({ required: true, enum: TeamType })
    type: TeamType;

    @Prop({ required: true })
    content: string;

    @Prop({ type: [MongooseSchema.Types.ObjectId], ref: 'UploadedFile', default: [] })
    media: MongooseSchema.Types.ObjectId[];
}

export const TeamSchema = SchemaFactory.createForClass(Team);