import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Team, TeamDocument, TeamType } from './schemas/team.schema';
import { UploadService } from '../common/services/main-upload.service';
import { CreateTeamDto } from './dto/team.dto';
import { UploadOptions } from '../common/interfaces/upload.interface';

@Injectable()
export class TeamService {
    constructor(
        @InjectModel(Team.name) private teamModel: Model<TeamDocument>,
        private readonly uploadService: UploadService,
    ) { }

    async findAllTeams(): Promise<{ data: TeamDocument[] }> {
        const teams = await this.teamModel.find().populate([
            {
                path: 'media',
                model: 'UploadedFile',
                select: 'id mimetype path type uploadedFrom',
                match: { _id: { $ne: null, $type: 'objectId' } }
            }
        ]).exec();

        return {
            data: teams,
        }
    }

    async getTeamByType(type: TeamType) {
        const team = await this.teamModel.findOne({ type }).populate([
            {
                path: 'media',
                model: 'UploadedFile',
                select: 'id mimetype path type uploadedFrom',
                match: { _id: { $ne: null, $type: 'objectId' } }
            }
        ]).exec();
        return {
            status: 'success',
            data: team
        };
    }

    async createTeam(teamDto: CreateTeamDto, files: Express.Multer.File[], req: any): Promise<TeamDocument> {
        let mediaIds: string[] = [];
        let uploadResult: any;

        try {
            if (files && files.length > 0) {
                const options: UploadOptions = {
                    path: 'teams',
                    type: 'photo',
                    multiple: true,
                    formField: 'files',
                };
                uploadResult = await this.uploadService.uploadFiles(files, options);
                if (!uploadResult.success) {
                    const errorMessages = uploadResult.errors.map(err => `${err.filename}: ${err.error}`).join(', ');
                    throw new BadRequestException(`File upload failed: ${errorMessages}`);
                }
                for (const file of uploadResult.files) {
                    if (file.type === 'image' || file.type === 'video') {
                        mediaIds.push(file.id);
                    }
                }
            }

            // Check if a team with the same type already exists
            const existingTeam = await this.teamModel.findOne({ type: teamDto.type }).exec();
            if (existingTeam) {
                existingTeam.set({
                    ...teamDto,
                    media: [...existingTeam.media.map(id => id.toString()), ...mediaIds],
                });
                return await existingTeam.save();
            } else {
                const newTeam = new this.teamModel({
                    ...teamDto,
                    media: mediaIds,
                });
                return await newTeam.save();
            }
        } catch (error) {
            if (uploadResult) {
                await this.uploadService.cleanupUploadedFiles(uploadResult);
            }
            throw error;
        }
    }
    async updateTeam(
        id: string,
        teamDto: CreateTeamDto,
        files: Express.Multer.File[],
        req: any
    ): Promise<{ message: string; team: TeamDocument }> {
        const existingTeam = await this.teamModel.findById(id).exec();
        if (!existingTeam) {
            throw new BadRequestException(`Team with ID '${id}' not found.`);
        }

        let finalMediaIds = existingTeam.media.map(id => id.toString());


        if (files && files.length > 0) {
            const options: UploadOptions = {
                path: 'teams',
                type: 'photo',
                multiple: true,
                formField: 'files',
            };
            const uploadResult = await this.uploadService.uploadFiles(files, options);
            for (const file of uploadResult.files) {
                if (file.type === 'image' || file.type === 'video') {
                    finalMediaIds.push(file.id);
                }
            }
        }
        if (teamDto.deleteIds && teamDto.deleteIds.length > 0) {
            const deleteResult = await this.uploadService.deleteFiles(teamDto.deleteIds);
            finalMediaIds = finalMediaIds.filter(id => !teamDto.deleteIds!.includes(id));
        }

        const finalFiles = { media: finalMediaIds };

        const updatedTeam = await this.teamModel
            .findByIdAndUpdate(
                id,
                {
                    ...teamDto,
                    media: finalFiles.media,
                },
                { new: true },
            )
            .populate([
                {
                    path: 'media',
                    model: 'UploadedFile',
                    select: 'id mimetype path type uploadedFrom',
                    match: { _id: { $ne: null, $type: 'objectId' } }
                }
            ])
            .exec();

        if (!updatedTeam) {
            throw new BadRequestException(`Failed to update team`);
        }

        const deletedCount = (teamDto.deleteIds || []).length;
        const addedCount = files ? files.length : 0;

        return {
            message: `Team updated successfully. ${deletedCount > 0 ? `Deleted ${deletedCount} files. ` : ''}Added ${addedCount} new files.`,
            team: updatedTeam,
        };
    }

    async deleteTeam(id: string): Promise<any> {
        const team = await this.teamModel.findById(id).exec();
        if (!team) {
            throw new BadRequestException(`Team with ID '${id}' not found.`);
        }

        // Delete associated files
        const allFileIds = [...team.media].map(id => id.toString());
        if (allFileIds.length > 0) {
            await this.uploadService.deleteFiles(allFileIds);
        }

        // Delete the team
        await this.teamModel.findByIdAndDelete(id).exec();

        return {
            status: 'success',
            message: 'Team deleted successfully'
        };
    }

}
