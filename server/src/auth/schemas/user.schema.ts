import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';
import { UploadedFile } from '../../common/schemas/uploaded-file.schema';
import * as mongooseEncryption from 'mongoose-encryption';

export type UserDocument = User & Document;

export enum Role {
  ADMIN = 'ADMIN',
  USER = 'USER',
}

@Schema({
  timestamps: true,
})
export class User {
  @Prop({ required: true })
  name: string;

  @Prop()
  phone?: string;

  @Prop({ enum: Role, default: Role.USER })
  role: Role;

  // @Prop()
  // userCode?: string;

  // @Prop({ default: true })
  // isActive: boolean;

  // @Prop({ default: false })
  // isVerified: boolean;

  // @Prop({ default: false })
  // isSubscribed: boolean;

  // @Prop()
  // subscriptionExpiry?: Date;

  @Prop()
  lastLogin?: Date;

  // @Prop({ type: Types.ObjectId, ref: 'UploadedFile' })
  // photo?: Types.ObjectId;

  @Prop({ default: false })
  isDeleted: boolean;

  // @Prop()
  // deletedAt?: Date;

  // @Prop()
  // fcmToken?: string;

  // @Prop()
  // addressLine1?: string;

  // @Prop()
  // addressLine2?: string;

  @Prop()
  city?: string;

  // @Prop()
  // state?: string;

  // @Prop()
  // zipCode?: string;

  // @Prop()
  // country?: string;
}

export const UserSchema = SchemaFactory.createForClass(User);

// UserSchema.index({ email: 1 });
UserSchema.index({ phone: 1 });

// // Pre-save hook to clean up invalid photo references
// UserSchema.pre('save', function () {
//   if (this.photo && (this.photo as any) === 'null') {
//     this.photo = undefined;
//   }
// });

// Pre-update hook to clean up invalid photo references
// UserSchema.pre(['updateOne', 'findOneAndUpdate'], function () {
//   const update = this.getUpdate() as any;
//   if (update && update.photo === 'null') {
//     update.photo = undefined;
//   }
//   if (update && update.$set && update.$set.photo === 'null') {
//     update.$set.photo = undefined;
//   }
// });
