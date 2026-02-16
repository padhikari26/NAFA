
import { Injectable, LoggerService } from '@nestjs/common';
import * as winston from 'winston';

@Injectable()
export class WinstonLogger implements LoggerService {
    private readonly logger: winston.Logger;

    constructor() {
        const consoleFormat = winston.format.combine(
            winston.format.colorize(),
            winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
            winston.format.printf(({ level, message, timestamp, context, ...meta }) => {
                let msg = typeof message === 'object' ? JSON.stringify(message, null, 2) : message;
                let ctx = context ? ` [${context}]` : '';
                return `${timestamp} ${level}${ctx}: ${msg}`;
            })
        );

        this.logger = winston.createLogger({
            level: 'info',
            format: winston.format.combine(
                winston.format.timestamp(),
                winston.format.json(),
            ),
            transports: [
                new winston.transports.Console({
                    format: consoleFormat,
                }),
                new winston.transports.File({ filename: 'logs/error.log', level: 'error' }),
                new winston.transports.File({ filename: 'logs/combined.log' }),
            ],
        });
    }

    log(message: any, context?: string) {
        this.logger.info(message, { context });
    }

    error(message: any, trace?: string, context?: string) {
        this.logger.error(message, { trace, context });
    }

    warn(message: any, context?: string) {
        this.logger.warn(message, { context });
    }
}
