const ModuleFederationPlugin = require("webpack/lib/container/ModuleFederationPlugin");

module.exports = {
  output: {
    uniqueName: "newFeature",
    publicPath: "auto",
  },
  optimization: {
    runtimeChunk: false,
  },
  experiments: {
    outputModule: true,
  },
  plugins: [
    new ModuleFederationPlugin({
      name: "newFeature",
      filename: "remoteEntry.js",
      exposes: {
        "./NewFeatureComponent": "./src/app/new-feature/new-feature.component.ts",
      },
      shared: {
        "@angular/core": { singleton: true, eager: true, version: "^17.0.0" },
        "@angular/common": { singleton: true, eager: true, version: "^17.0.0" },
        "@angular/router": { singleton: true, eager: true, version: "^17.0.0" },
      },
    }),
  ],
};
