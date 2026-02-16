import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { MongooseModule } from '@nestjs/mongoose';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { JwtStrategy } from './strategies/jwt.strategy';
import { User, UserSchema } from './schemas/user.schema';
import { Admin, AdminSchema } from './schemas/admin.schema';
import { MemberService } from '../member/member.service';
import { uploadModule } from '../common/modules/professional-upload.module';
import { LoginCode, LoginCodeSchema } from './schemas/login-code.schema';

@Module({
  imports: [
    PassportModule,
    JwtModule.registerAsync({
      imports: [ConfigModule],
      useFactory: async (configService: ConfigService) => ({
        secret: configService.get<string>('JWT_SECRET'),
      }),
      inject: [ConfigService],
    }),
    MongooseModule.forFeature([{ name: User.name, schema: UserSchema }, { name: Admin.name, schema: AdminSchema }, { name: LoginCode.name, schema: LoginCodeSchema }]),
    uploadModule
  ],
  controllers: [AuthController],
  providers: [AuthService, JwtStrategy, MemberService, MemberService],
  exports: [AuthService],
})
export class AuthModule { }
