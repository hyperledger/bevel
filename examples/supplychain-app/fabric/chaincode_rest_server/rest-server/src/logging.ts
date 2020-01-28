import * as Koa from 'koa';
import * as winston from 'winston';
import { config } from './config';

export function logger(winstonInstance) {
  winstonInstance.configure({
    level: config.debugLogging ? 'debug' : 'info',
    transports: [
      new winston.transports.File({ filename: 'error.log', level: 'error' }),
      new winston.transports.Console({
        format: winston.format.combine(winston.format.colorize({ all: true }), winston.format.simple()),
      }),
    ],
  });

  return async (ctx: Koa.Context, next: () => Promise<any>) => {
    const start = new Date().getMilliseconds();

    await next();

    const ms = new Date().getMilliseconds() - start;

    let logLevel: string = 'debug';

    if (ctx.status >= 300) {
      logLevel = 'info';
    }
    if (ctx.status >= 400) {
      logLevel = 'warn';
    }
    if (ctx.status >= 500) {
      logLevel = 'error';
    }
    const msg: string = `${ctx.method} ${ctx.originalUrl} ${ctx.status} ${ms}ms`;

    winstonInstance.log(logLevel, msg);
  };
}
