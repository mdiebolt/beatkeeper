var path = require("path");
module.exports = {
  module: {
    loaders: [
      { test: /\.coffee$/, loader: "coffee" }
    ]
  },
  entry: {
    app: ["./src/javascripts/main.coffee"]
  },
  output: {
    path: path.resolve(__dirname, "dist"),
    filename: "bundle.js"
  }
};
