const proxy = require('http-proxy-middleware');
const pkg = require('../package.json');
const node = process.argv[2];
const target = pkg.nodes[node];

module.exports = function(app) {
  target &&
  app.use(proxy('/api', { target }));
};