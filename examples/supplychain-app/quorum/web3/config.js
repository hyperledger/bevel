const dotenv = require('dotenv');
dotenv.config();
module.exports = {
  endpoint: process.env.API_URL,
  port: process.env.PORT
};
