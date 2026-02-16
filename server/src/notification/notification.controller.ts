// notification.controller.ts
import { Body, Controller, Delete, Param, Post, UseGuards } from '@nestjs/common';
import { NotificationService } from './notification.service';
import { SendNotificationToAllDto, SendNotificationToTokensDto } from './dto/notification.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { Role } from '../auth/schemas/user.schema';
import { Roles } from '../common/decorators/roles.decorator';
import { RolesGuard } from '../common/guards/roles.guard';
import { FilterDto } from 'src/common/dto/filter.dto';
import { Public } from 'src/common/decorators/public.decorator';



@Controller('notification')
export class NotificationController {
    constructor(private readonly notificationService: NotificationService) { }
    @UseGuards(JwtAuthGuard)
    @Post('all')
    async getAllNotifications(
        @Body() filters: FilterDto
    ) {
        return this.notificationService.findAll(filters);
    }

    @UseGuards(JwtAuthGuard, RolesGuard)
    @Roles(Role.ADMIN)
    @Post('create')
    async sendNotificationToAll(@Body() dto: SendNotificationToAllDto) {
        const message = {
            notification: {
                title: dto.title,
                body: dto.body,
            },
            data: dto.data || {},
        };
        const response = await this.notificationService.sendNotificationToTopic('all', message as any);
        return { message: 'Notification sent to topic "all"', response };
    }

    //delete
    @UseGuards(JwtAuthGuard, RolesGuard)
    @Roles(Role.ADMIN)
    @Delete(':id')
    async deleteNotification(@Param('id') id: string) {
        return this.notificationService.deleteNotification(id);
    }

}
