import { MongooseModule } from '@nestjs/mongoose';
import { uploadModule } from 'src/common/modules/professional-upload.module';
import { TeamController } from './team.controller';
import { UploadedFile, UploadedFileSchema } from 'src/common/schemas/uploaded-file.schema';
/*
https://docs.nestjs.com/modules
*/

import { Module } from '@nestjs/common';
import { Team, TeamSchema } from './schemas/team.schema';
import { TeamService } from './team.service';

@Module({
    imports: [
        MongooseModule.forFeature([
            { name: Team.name, schema: TeamSchema },
            { name: UploadedFile.name, schema: UploadedFileSchema },
        ]),
        uploadModule,
    ],
    controllers: [TeamController],
    providers: [TeamService],
})
export class TeamModule { }
