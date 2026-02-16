
import {
    CallHandler,
    ExecutionContext,
    Injectable,
    NestInterceptor,
} from '@nestjs/common';
import { Observable, tap, catchError, throwError } from 'rxjs';
import { WinstonLogger } from '../logger/winston-logger.service';

@Injectable()
export class LoggingInterceptor implements NestInterceptor {
    constructor(private readonly logger: WinstonLogger) { }

    private safeStringify(obj: any, maxLength: number = 500): string {
        try {
            if (obj === undefined || obj === null) {
                return String(obj);
            }
            if (typeof obj === 'string') {
                return obj.substring(0, maxLength);
            }
            // Handle circular references
            const seen = new WeakSet();
            const result = JSON.stringify(obj, (key, value) => {
                if (typeof value === 'object' && value !== null) {
                    if (seen.has(value)) {
                        return '[Circular]';
                    }
                    seen.add(value);
                }
                return value;
            });
            return result.substring(0, maxLength);
        } catch (error) {
            return '[Serialization Error]';
        }
    }

    intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
        const req = context.switchToHttp().getRequest();
        const res = context.switchToHttp().getResponse();

        const { method, url, ip, body, query, headers } = req;
        const safeBody = { ...body };
        if (safeBody.password) safeBody.password = '***';

        this.logger.log({
            url,
            trackId: req.trackId,
            type: 'REQUEST',
            method,
            ip,
            query,
            headers: { 'user-agent': headers['user-agent'] },
        });

        const now = Date.now();

        return next.handle().pipe(
            tap((data) => {
                const logObj: any = {
                    trackId: req.trackId,
                    type: 'RESPONSE',
                    method,
                    url,
                    ip,
                    statusCode: res.statusCode,
                    responseTime: `${Date.now() - now}ms`,
                };
                // Only log responseBody for non-successful responses
                if (!(res.statusCode >= 200 && res.statusCode < 300)) {
                    if (data !== undefined && data !== null) {
                        logObj.responseBody = this.safeStringify(data, 500);
                    }
                }
                this.logger.log(logObj);
            }),
            catchError((err) => {
                this.logger.error(
                    {
                        trackId: req.trackId,
                        type: 'ERROR',
                        method,
                        url,
                        ip,
                        body: safeBody,
                        query,
                        error: err.message,
                        stack: err.stack,
                    },
                    err.stack,
                );
                return throwError(() => err);
            }),
        );
    }
}
