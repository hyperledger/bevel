import * as cors from '@koa/cors';
import * as dotenv from 'dotenv';
import * as Koa from 'koa';
import * as bodyParser from 'koa-bodyparser';
import 'reflect-metadata';
import * as winston from 'winston';

import { readFileSync } from 'fs';
import { config } from './config';
import { logger } from './logging';
import { router } from './routes';
import { User } from './User';

dotenv.config({ path: '.env' });

const app = new Koa();

app.use(cors());

app.use(logger(winston));

app.use(bodyParser());

app.use(router.routes());

// Config
const orgID = process.env.ORG_ID;
const username = process.env.USER;
const certPath = process.env.CERT;
const keyPath = process.env.KEY;

const user = new User(`./identities/${username}/wallet`, username);
const cert = readFileSync(certPath).toString();
const key = readFileSync(keyPath).toString();
user.createIdentity(cert, key, orgID);
app.context.user = user;

app.listen(config.port);
console.info(`Server running on port ${config.port}`);
