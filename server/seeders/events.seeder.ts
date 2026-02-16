import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Event, EventDocument } from '../src/events/schemas/events.schema';

@Injectable()
export class EventsSeeder {
    constructor(
        @InjectModel(Event.name) private eventModel: Model<EventDocument>,
    ) { }

    async seed() {
        const existingEvents = await this.eventModel.countDocuments();
        if (existingEvents > 0) {
            console.log('Events already seeded');
            return;
        }

        const events = [
            {
                title: 'Annual Tech Conference 2024',
                description: 'A comprehensive technology conference featuring the latest innovations in software development, AI, and digital transformation.',
                date: new Date('2024-09-15T09:00:00Z'),
            },
            {
                title: 'Community Service Drive',
                description: 'Join us for a community service initiative to help local families and support environmental conservation efforts.',
                date: new Date('2024-08-20T08:00:00Z'),
            },
            {
                title: 'Professional Development Workshop',
                description: 'Enhance your career skills with our professional development workshop covering leadership, communication, and project management.',
                date: new Date('2024-10-05T14:00:00Z'),
            },
            {
                title: 'Cultural Heritage Festival',
                description: 'Celebrate our rich cultural heritage with traditional music, dance performances, and authentic cuisine from various regions.',
                date: new Date('2024-11-12T17:00:00Z'),
            },
            {
                title: 'Entrepreneurship Summit',
                description: 'Connect with successful entrepreneurs and learn about startup strategies, funding opportunities, and business innovation.',
                date: new Date('2024-09-28T10:00:00Z'),
            },
            {
                title: 'Health and Wellness Seminar',
                description: 'Expert-led sessions on mental health awareness, nutrition, fitness, and maintaining work-life balance.',
                date: new Date('2024-08-30T13:00:00Z'),
            },
            {
                title: 'Youth Leadership Program',
                description: 'Empowering young leaders with skills, knowledge, and opportunities to make a positive impact in their communities.',
                date: new Date('2024-10-18T15:00:00Z'),
            },
            {
                title: 'Digital Marketing Masterclass',
                description: 'Learn cutting-edge digital marketing strategies including social media marketing, SEO, and content creation techniques.',
                date: new Date('2024-09-08T11:00:00Z'),
            },
            {
                title: 'Environmental Conservation Rally',
                description: 'Raise awareness about climate change and environmental protection through community engagement and educational activities.',
                date: new Date('2024-11-25T09:30:00Z'),
            },
            {
                title: 'Career Fair 2024',
                description: 'Meet potential employers, explore career opportunities, and network with industry professionals across various sectors.',
                date: new Date('2024-10-10T12:00:00Z'),
            },
            {
                title: 'Innovation Challenge',
                description: 'Participate in our innovation challenge to develop creative solutions for real-world problems and win exciting prizes.',
                date: new Date('2024-12-03T16:00:00Z'),
            },
            {
                title: 'Financial Literacy Workshop',
                description: 'Learn essential financial skills including budgeting, investing, savings strategies, and retirement planning.',
                date: new Date('2024-09-22T14:30:00Z'),
            },
            {
                title: 'Sports Tournament',
                description: 'Annual multi-sport tournament featuring football, basketball, volleyball, and other competitive sports events.',
                date: new Date('2024-11-08T08:00:00Z'),
            },
            {
                title: 'Art and Creativity Exhibition',
                description: 'Showcase your artistic talents in our community art exhibition featuring paintings, sculptures, and digital art.',
                date: new Date('2024-10-25T18:00:00Z'),
            },
            {
                title: 'Networking Mixer',
                description: 'Connect with like-minded professionals, share ideas, and build meaningful relationships in a relaxed social setting.',
                date: new Date('2024-12-15T19:00:00Z'),
            },
        ];

        await this.eventModel.insertMany(events);
        console.log('Events seeded successfully');
    }
}
