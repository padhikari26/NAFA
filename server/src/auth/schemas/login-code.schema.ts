import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type LoginCodeDocument = LoginCode & Document;

@Schema({
    timestamps: true,
})
export class LoginCode {
    @Prop({ required: true })
    code: string;
}
export const LoginCodeSchema = SchemaFactory.createForClass(LoginCode);
