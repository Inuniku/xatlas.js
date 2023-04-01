const webpack = require("webpack");
const path = require("path");

const SRC_PATH = path.resolve(__dirname, 'source', 'web');
const NODE_MOD_PATH = path.resolve(__dirname, 'node_modules');
const BUILD_PATH = path.resolve(__dirname, 'dist');
const BUILD_FILE_NAME = 'xatlas';
const LIBRARY_NAME = 'XAtlas';
const LIBRARY_TARGET = 'self';
// const MODE = "development"
const MODE = "production"

const entry = {
};

entry[BUILD_FILE_NAME] = path.join(SRC_PATH, 'index.js');

module.exports = {
    mode: MODE,
    devtool: 'source-map',
    entry: entry,
    output: {
        filename: '[name].js',
        path: BUILD_PATH,
        library: LIBRARY_NAME,
        libraryTarget: LIBRARY_TARGET,
        globalObject: 'this',
    },
    // This is necessary due to the fact that emscripten puts both Node and web
    // code into one file. The node part uses Node’s `fs` module to load the wasm
    // file.
    // Issue: https://github.com/kripken/emscripten/issues/6542.

    resolve: {
        modules: [SRC_PATH, NODE_MOD_PATH],
    },
    module: {
        rules: [
            {
                test: /\.worker\.js/,
                use: {
                    loader: "worker-loader",
                    options: { fallback: true }
                }
            },
            {
                test: /\.wasm$/,
                type: 'javascript/auto',
                loader: 'file-loader',
            }
        ]
    },
};
