import { TeamModule } from './team/team.module';
import { TeamController } from './team/team.controller';
import { MemberModule } from './member/member.module';
import { NotificationModule } from './notification/notification.module';
import { EventsModule } from './events/events.module';
import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { MongooseModule } from '@nestjs/mongoose';
import { ThrottlerModule } from '@nestjs/throttler';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { FirebaseModule } from './firebase/firebase.module';
import { RolesGuard } from './common/guards/roles.guard';
import { APP_GUARD } from '@nestjs/core';
import { JwtAuthGuard } from './auth/guards/jwt-auth.guard';
import { FileController } from './common/controllers/file.controller';
import { GalleryModule } from './gallery/gallery.module';
import { WinstonLogger } from './common/logger/winston-logger.service';
import { LoggerModule } from './common/logger/logger.module';
import { BackupModule } from './common/modules/backup.module';

@Module({
  imports: [
    LoggerModule,
    BackupModule,
    TeamModule,
    GalleryModule,
    MemberModule,
    NotificationModule,
    EventsModule,
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    MongooseModule.forRoot(process.env.MONGODB_URI || 'mongodb://localhost:27017/nestjs-auth'),
    ThrottlerModule.forRoot([{
      ttl: 60000,
      limit: 10,
    }]),
    AuthModule,
    FirebaseModule,
  ],
  controllers: [
    AppController, FileController],
  providers: [
    WinstonLogger,
    AppService,
    JwtAuthGuard,
    RolesGuard,
    {
      provide: APP_GUARD,
      useClass: JwtAuthGuard,
    },
    {
      provide: APP_GUARD,
      useClass: RolesGuard,
    },
  ], exports: [JwtAuthGuard, RolesGuard],
})
export class AppModule { }
