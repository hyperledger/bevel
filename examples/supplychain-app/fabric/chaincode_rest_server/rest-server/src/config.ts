import * as dotenv from 'dotenv';

dotenv.config({ path: '.env' });

export interface IConfig {
  port: number;
  debugLogging: boolean;
}

const config: IConfig = {
  port: parseInt(process.env.PORT, 10) || 3000,
  debugLogging: process.env.NODE_ENV === 'development',
};

export { config };
