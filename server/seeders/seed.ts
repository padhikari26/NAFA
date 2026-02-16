import { NestFactory } from '@nestjs/core';
import { MongooseModule } from '@nestjs/mongoose';
import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { EventsSeeder } from './events.seeder';
import { MembersSeeder } from './members.seeder';
import { Event, EventSchema } from '../src/events/schemas/events.schema';
import { User, UserSchema } from '../src/auth/schemas/user.schema';

@Module({
    imports: [
        ConfigModule.forRoot({
            isGlobal: true,
        }),
        MongooseModule.forRoot(process.env.MONGODB_URI || 'mongodb://localhost:27017/nafusa'),
        MongooseModule.forFeature([
            { name: Event.name, schema: EventSchema },
            { name: User.name, schema: UserSchema },
        ]),
    ],
    providers: [EventsSeeder, MembersSeeder],
})
export class SeederModule { }

async function bootstrap() {
    const app = await NestFactory.createApplicationContext(SeederModule);

    try {
        console.log('Starting database seeding...');

        const eventsSeeder = app.get(EventsSeeder);
        await eventsSeeder.seed();

        const membersSeeder = app.get(MembersSeeder);
        await membersSeeder.seed();

        console.log('Database seeding completed successfully!');
    } catch (error) {
        console.error('Error during seeding:', error);
    } finally {
        await app.close();
    }
}

bootstrap();
