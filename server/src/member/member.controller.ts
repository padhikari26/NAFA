/*
https://docs.nestjs.com/controllers#controllers
*/

import { Controller, Body, UseGuards, Get, Request, Patch, Post, UseInterceptors, Put, UploadedFile, Param, Res, Delete } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { Response } from 'express';
import { Types } from 'mongoose';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { Role, User } from '../auth/schemas/user.schema';
import { MemberService } from './member.service';
import { UploadService } from '../common/services/main-upload.service';
import { MemberFilterDto } from './dto/filter.dto';
import { Roles } from '../common/decorators/roles.decorator';
import { RolesGuard } from '../common/guards/roles.guard';
import { Public } from '../common/decorators/public.decorator';
import { GetUser } from '../auth/decorator/auth.decorator';

@Controller('member')
export class MemberController {

    constructor(
        private readonly memberService: MemberService,
        private readonly uploadService: UploadService
    ) { }

    @UseGuards(JwtAuthGuard)
    @Get('profile')
    async getProfile(@GetUser('id') userId: string,) {
        const user = await this.memberService.findById(userId);
        return user;
    }

    @UseGuards(JwtAuthGuard)
    @Roles(Role.USER, Role.ADMIN)
    @Put('profile/:id')
    async updateProfile(
        @Request() req: any,
        @Param('id') id: string,
        @Body() updateData: Partial<User>
    ) {
        try {
            // Pass photo file to service, let service handle upload and update
            const updatedUser = await this.memberService.updateUserProfile(id || req.user.id || '', updateData);
            return {
                user: updatedUser
            };
        } catch (error) {

            throw error;
        }
    }



    //update FCM token
    // @UseGuards(JwtAuthGuard)
    // @Patch('fcm-token')
    // async updateFcmToken(@Request() req: any, @Body('fcmToken') fcmToken: string) {
    //     return this.memberService.updateFCMToken(req.user.id, fcmToken);
    // }

    @UseGuards(JwtAuthGuard, RolesGuard)
    @Roles(Role.ADMIN)
    @Post('all')
    async getAllMembers(@Body() filters: MemberFilterDto) {
        return this.memberService.findAll(filters);
    }

    @UseGuards(JwtAuthGuard, RolesGuard)
    @Roles(Role.ADMIN)
    @Get('download-csv')
    async downloadMembersCsv(@Res() res: Response) {
        try {
            const csvContent = await this.memberService.downloadMembersCsv();
            const timestamp = new Date().toISOString().split('T')[0]; // YYYY-MM-DD format
            const filename = `members-${timestamp}.csv`;
            res.setHeader('Content-Type', 'text/csv');
            res.setHeader('Content-Disposition', `attachment; filename="${filename}"`);
            res.send(csvContent);
        } catch (error) {
            if (!res.headersSent) {
                res.status(500).json({ message: 'Error generating CSV file' });
            }
            throw error;
        }
    }

    //delete user account
    @UseGuards(JwtAuthGuard)
    @Roles(Role.USER, Role.ADMIN)
    @Delete('delete-account/:id')
    async deleteAccount(@Param('id') userId: string) {
        return this.memberService.deleteAccount(userId);
    }
    // @Public()
    // @Get('generate-code')
    // async generateUniqueCode() {
    //     return this.memberService.generateUniqueUserCode();
    // }

}
