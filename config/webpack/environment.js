const { environment } = require("@rails/webpacker");

const webpack = require("webpack");
environment.plugins.append(
  "Provide",
  new webpack.ProvidePlugin({
    $: "jquery",
    jQuery: "jquery",
    popper: ["popper.js", "default"],
    _: "underscore"
  })
);

module.exports = environment;

environment.loaders.append("gmaps4rails", {
  test: /gmaps_google/,
  use: [
    {
      loader: "imports-loader",
      options: "this=>window"
    }
  ]
});
