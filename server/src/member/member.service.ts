/*
https://docs.nestjs.com/providers#services
*/

import { BadRequestException, Injectable, UnauthorizedException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User, UserDocument } from '../auth/schemas/user.schema';
import { paginateAndFilter } from '../common/utils/paginate.utils';
import { UploadService } from '../common/services/main-upload.service';
import { MemberFilterDto } from './dto/filter.dto';
import { Parser } from 'json2csv';
import { filter } from 'compression';

@Injectable()
export class MemberService {
    constructor(
        @InjectModel(User.name) private userModel: Model<UserDocument>,
        private readonly uploadService: UploadService,
    ) { }

    async findById(id: string): Promise<User | null> {
        // Clean up any invalid photo reference for this specific user
        // await this.userModel.updateOne(
        //     { _id: id, photo: "null" },
        //     { $unset: { photo: "" } }
        // ).exec();

        const user = await this.userModel
            .findById(id)
            .select('-password')
            .exec();

        return user;
    }

    // async updateFCMToken(userId: string, fcmToken: string): Promise<User | null> {
    //     const user = await this.userModel.findById(userId);
    //     if (!user || user.isDeleted) {
    //         return null;
    //     }
    //     user.fcmToken = fcmToken;
    //     await user.save();
    //     return user;
    // }

    async updateUserProfile(userId: string, updateData: Partial<User>): Promise<User | null> {
        const user = await this.userModel.findById(userId);
        if (!user || user.isDeleted) {
            throw new BadRequestException('User not found or deleted');
        }
        try {
            Object.assign(user, updateData);
            const savedUser = await user.save();
            return savedUser;
        } catch (error) {
            throw error;
        }
    }

    async deleteAccount(userId: string): Promise<{ message: string }> {
        const user = await this.userModel.findByIdAndDelete(userId);
        if (!user) {
            throw new BadRequestException('User not found');
        }
        return { message: 'User account deleted successfully' };
    }

    // // Generates a random alphanumeric code of specified length (default: 6)
    // generateRandomCode(length: number = 6): string {
    //     const prefix = 'NAFA';
    //     const characters = '0123456789';
    //     let result = '';
    //     for (let i = 0; i < length - prefix.length; i++) {
    //         result += characters.charAt(Math.floor(Math.random() * characters.length));
    //     }
    //     return prefix + result;
    // }

    // // Generates a unique user code that does not already exist in the database
    // async generateUniqueUserCode(): Promise<{ userCode: string }> {
    //     let userCode: string;
    //     const maxAttempts = 10;
    //     let attempts = 0;

    //     while (attempts < maxAttempts) {
    //         userCode = this.generateRandomCode(10);
    //         const existingUser = await this.userModel.findOne({ userCode, isDeleted: false });

    //         if (!existingUser) {
    //             return {
    //                 userCode: userCode
    //             }
    //         }

    //         attempts++;
    //     }
    //     throw new Error('Unable to generate a unique user code after multiple attempts.');
    // }


    async findAll(filters: MemberFilterDto): Promise<any> {
        // First, clean up any invalid photo references in the database
        // await this.userModel.updateMany(
        //     { photo: "null" },
        //     { $unset: { photo: "" } }
        // ).exec();

        //show updatedAt , newest first

        const userFilters = {
            ...filters,
            sort: 'updatedAt',
            order: 'desc',
        }

        const result = await paginateAndFilter<UserDocument>(
            this.userModel,
            userFilters,
            ['name', 'phone'],
        );

        // const populatedData = await this.userModel.populate(result.data, [
        //     {
        //         path: 'photo',
        //         model: 'UploadedFile',
        //         select: 'id mimetype path type uploadedFrom'
        //     },
        // ]);
        return result
    }

    async downloadMembersCsv(): Promise<string> {
        const users = await this.userModel.find();
        const plainUsers = users.map(u => u.toObject());

        const fields = [
            { label: 'Name', value: 'name' },
            {
                label: 'Phone',
                value: (row: any) => row.phone ? `="${row.phone.toString()}"` : '' // Excel formula format to force text
            },
            { label: 'Role', value: 'role' },
            { label: 'City', value: 'city' },
            {
                label: 'Last Login',
                value: (row: any) =>
                    row.lastLogin ? new Date(row.lastLogin).toISOString() : '',
            },
            {
                label: 'Created At',
                value: (row: any) =>
                    row.createdAt ? new Date(row.createdAt).toISOString() : '',
            },
        ];

        const parser = new Parser({ fields });
        return parser.parse(plainUsers);
    }

}
