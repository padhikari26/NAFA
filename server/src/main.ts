import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import helmet from 'helmet';
import * as compression from 'compression';
import rateLimit from 'express-rate-limit';
import { NestExpressApplication } from '@nestjs/platform-express';
import { join } from 'path';
import { PathUtils } from './common/utils/path.utils';
import { WinstonLogger } from './common/logger/winston-logger.service';
import { trackIdMiddleware } from './common/middleware/trackId.middleware';
import { LoggingInterceptor } from './common/interceptors/logger.interceptor';
import { AllExceptionsFilter } from './common/filters/all-exceptions.filter';
import { BackupService } from './common/services/backup.service';



async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule);
  const logger = app.get(WinstonLogger);
  app.useGlobalInterceptors(new LoggingInterceptor(logger));
  app.useGlobalFilters(new AllExceptionsFilter(logger));

  // Initialize backup service for uploads folder only in production
  if (process.env.NODE_ENV === 'production') {
    const backupService = app.get(BackupService);
    backupService.startDailyBackup();
    logger.log('📁 Uploads backup service initialized');
  }

  // Serve static files
  app.useStaticAssets(PathUtils.getUploadsPath(), {
    prefix: '/uploads/',
  });

  // TrackId middleware
  app.use(trackIdMiddleware);

  // Security headers
  app.use(helmet());
  app.use((req, res, next) => {
    res.setHeader(
      'Strict-Transport-Security',
      'max-age=31536000; includeSubDomains',
    );
    res.setHeader('X-Frame-Options', 'DENY');
    res.setHeader('X-Content-Type-Options', 'nosniff');
    res.setHeader(
      'Content-Security-Policy',
      "default-src 'self'; img-src 'self' data:; script-src 'self'; style-src 'self' 'unsafe-inline';",
    );
    next();
  });

  // // CSRF protection for browser clients
  // if (process.env.ENABLE_CSRF === 'true') {
  //   app.use(cookieParser());
  //   const csurf = require('csurf');
  //   app.use(csurf({ cookie: true }));

  //   // CSRF error handler
  //   app.use((err, req, res, next) => {
  //     if (err.code === 'EBADCSRFTOKEN') {
  //       return res.status(403).json({
  //         message: 'Invalid CSRF token',
  //         trackId: req.trackId,
  //       });
  //     }
  //     next(err);
  //   });

  //   app.use('/api/csrf-token', (req, res) => {
  //     res.json({ csrfToken: req.csrfToken() });
  //   });
  // }

  app.use(compression());
  app.use(
    rateLimit({
      windowMs: 60 * 1000, // 1 minute
      max: 180, // limit each IP to 60 requests per windowMs
      message: 'Too many requests, try again later',
      standardHeaders: true,
      legacyHeaders: false,
    }),
  );

  // CORS
  app.enableCors({
    origin:
      process.env.NODE_ENV === 'production'
        ? process.env.ALLOWED_ORIGINS?.split(',')
        : ['http://localhost:3000', 'http://localhost:3001', 'https://nafausa-admin.vercel.app'],
    credentials: true,
  });

  // Global pipes
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );

  // Global prefix
  app.setGlobalPrefix('api');

  const port = process.env.PORT ?? 3001;

  // Enforce HTTPS in production
  if (process.env.NODE_ENV === 'production') {
    app.use((req, res, next) => {
      if (req.headers['x-forwarded-proto'] !== 'https') {
        return res.redirect('https://' + req.headers.host + req.url);
      }
      next();
    });
    await app.listen(port);
    logger.log(`🚀 Production server running on port ${port}`);
  } else {
    const host = '0.0.0.0';
    await app.listen(port, host, () => {
      logger.log(`🔥 Development server running on http://localhost:${port}`);
    });
  }
}

bootstrap();
