exports.files = {
  javascripts: {
    joinTo: {
      'vendor.js': /^(?!app)/,
      'app.js': /^app/
    }
  },
  stylesheets: {joinTo: 'app.css'}
};

exports.watcher = {
  awaitWriteFinish: true,
  usePolling: true
}

exports.plugins = {
  babel: {
    "presets": ["env", "react", "stage-0"],
    "plugins": ["transform-class-properties", "transform-async-to-generator", "transform-runtime"]
  },
  pug:{
    preCompile: true,
    preCompilePattern: /.html.pug$/,
    pugRuntime: require('path').resolve('.', 'vendor', 'pug_runtime.js'),
    globals: ['App']
  },
  autoReload: {
    enabled: {
      css: true,
      js: true,
      assets: true
    },
    delay: 200,
  }
};
