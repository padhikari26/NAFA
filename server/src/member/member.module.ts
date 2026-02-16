import { MongooseModule } from '@nestjs/mongoose';
import { User, UserSchema } from '../auth/schemas/user.schema';
import { MemberController } from './member.controller';
import { MemberService } from './member.service';
import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { uploadModule } from '../common/modules/professional-upload.module';

@Module({
    imports: [
        JwtModule.register({}),
        MongooseModule.forFeature([{ name: User.name, schema: UserSchema },]),
        uploadModule,
    ],
    controllers: [
        MemberController,],
    providers: [
        MemberService,
    ],
})
export class MemberModule { }
