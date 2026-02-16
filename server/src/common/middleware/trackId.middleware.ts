
import { v4 as uuidv4 } from 'uuid';
import { Request, Response, NextFunction } from 'express';

export function trackIdMiddleware(req: Request, res: Response, next: NextFunction) {
    const trackId = uuidv4();
    (req as any).trackId = trackId;
    res.setHeader('X-Track-Id', trackId);
    next();
}
