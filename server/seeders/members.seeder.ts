import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User, UserDocument, Role } from '../src/auth/schemas/user.schema';

@Injectable()
export class MembersSeeder {
    constructor(
        @InjectModel(User.name) private userModel: Model<UserDocument>,
    ) { }

    async seed() {
        const existingMembers = await this.userModel.countDocuments({ role: Role.USER });
        if (existingMembers > 0) {
            console.log('Members already seeded');
            return;
        }

        const members = [
            {
                name: 'John Smith',
                email: 'john.smith@email.com',
                phone: '+1-555-0101',
                role: Role.USER,
                isActive: true,
                isVerified: true,
            },
            {
                name: 'Sarah Johnson',
                email: 'sarah.johnson@email.com',
                phone: '+1-555-0102',
                role: Role.USER,
                isActive: true,
                isVerified: true,
            },
            {
                name: 'Michael Brown',
                email: 'michael.brown@email.com',
                phone: '+1-555-0103',
                role: Role.USER,
                isActive: true,
                isVerified: false,
            },
            {
                name: 'Emily Davis',
                email: 'emily.davis@email.com',
                phone: '+1-555-0104',
                role: Role.USER,
                isActive: true,
                isVerified: false,
            },
            {
                name: 'David Wilson',
                email: 'david.wilson@email.com',
                phone: '+1-555-0105',
                role: Role.USER,
                isActive: true,
                isVerified: false,
            },
            {
                name: 'Jessica Martinez',
                email: 'jessica.martinez@email.com',
                phone: '+1-555-0106',
                role: Role.USER,
                isActive: false,
                isVerified: true,
            },
            {
                name: 'Christopher Lee',
                email: 'christopher.lee@email.com',
                phone: '+1-555-0107',
                role: Role.USER,
                isActive: true,
                isVerified: true,
            },
            {
                name: 'Amanda Garcia',
                email: 'amanda.garcia@email.com',
                phone: '+1-555-0108',
                role: Role.USER,
                isActive: true,
                isVerified: false,
            },
            {
                name: 'Matthew Taylor',
                email: 'matthew.taylor@email.com',
                phone: '+1-555-0109',
                role: Role.USER,
                isActive: true,
                isVerified: true,
            },
            {
                name: 'Ashley Anderson',
                email: 'ashley.anderson@email.com',
                phone: '+1-555-0110',
                role: Role.USER,
                isActive: true,
                isVerified: true,
            },
            {
                name: 'Ryan Thomas',
                email: 'ryan.thomas@email.com',
                phone: '+1-555-0111',
                role: Role.USER,
                isActive: true,
                isVerified: false,
            },
            {
                name: 'Lauren Jackson',
                email: 'lauren.jackson@email.com',
                phone: '+1-555-0112',
                role: Role.USER,
                isActive: false,
                isVerified: false,
            },
            {
                name: 'Kevin White',
                email: 'kevin.white@email.com',
                phone: '+1-555-0113',
                role: Role.USER,
                isActive: true,
                isVerified: true,
            },
            {
                name: 'Nicole Harris',
                email: 'nicole.harris@email.com',
                phone: '+1-555-0114',
                role: Role.USER,
                isActive: true,
                isVerified: true,
            },
            {
                name: 'Brandon Clark',
                email: 'brandon.clark@email.com',
                phone: '+1-555-0115',
                role: Role.USER,
                isActive: true,
                isVerified: false,
            },
        ];

        await this.userModel.insertMany(members);
        console.log('Members seeded successfully');
    }
}
