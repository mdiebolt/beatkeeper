var path = require("path");
module.exports = {
  cache: true,
  contentBase: __dirname + "/src/",
  entry: {
    app: "javascripts/main"
  },
  output: {
    path: path.resolve(__dirname, "dist"),
    publicPath: "dist/",
    filename: "bundle.js"
  },
  module: {
    loaders: [{
      test: /\.coffee$/,
      loader: "coffee"
    }]
  },
  resolve: {
    extensions: ['', '.webpack.js', '.web.js', '.coffee', '.js', '.scss'],
    modulesDirectories: ['src', 'src/javascripts', 'web_modules', 'bower_components', 'node_modules']
  }
};
