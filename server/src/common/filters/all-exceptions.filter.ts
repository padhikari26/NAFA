import {
    ExceptionFilter,
    Catch,
    ArgumentsHost,
    HttpException,
} from '@nestjs/common';
import { Request, Response } from 'express';
import { WinstonLogger } from '../logger/winston-logger.service';

@Catch()
export class AllExceptionsFilter implements ExceptionFilter {
    constructor(private readonly logger: WinstonLogger) { }

    catch(exception: unknown, host: ArgumentsHost) {
        const ctx = host.switchToHttp();
        const request = ctx.getRequest<Request>();
        const response = ctx.getResponse<Response>();
        const status =
            exception instanceof HttpException
                ? exception.getStatus()
                : 500;
        const message =
            exception instanceof HttpException
                ? exception.getResponse()
                : exception;

        this.logger.error({
            url: request.url,
            method: request.method,
            ip: request.ip,
            trackId: (request as any).trackId || null,
            type: 'ERROR',
            error: message,
        });

        // Only send response if headers haven't been sent yet
        if (!response.headersSent) {
            response.status(status).json(message);
        }
    }
}
