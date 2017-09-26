// Author vhl
const path = require('path')
const webpack = require('webpack')
const ExtractTextPlugin = require('extract-text-webpack-plugin')
const OptimizeCssAssetsPlugin = require('optimize-css-assets-webpack-plugin')
const WebpackNotifierPlugin = require('webpack-notifier')

const DEBUG = process.env.NODE_ENV !== 'production'

const APP_FOLDER = path.resolve(__dirname, './src')
const DIST_FOLDER = path.resolve(__dirname, './public')
const DIST_FOLDER_STYLE = path.resolve(DIST_FOLDER, './style')

const DIST_FILE_JS_BUNDLE = 'app.js'
const DIST_FILE_CSS_BUNDLE_NAME = 'app.css'
const DIST_FILE_CSS_BUNDLE = `style/${DIST_FILE_CSS_BUNDLE_NAME}`

const SRC_FOLDER = path.resolve(APP_FOLDER, './')
const SRC_FILE_JS_APP = path.resolve(SRC_FOLDER, './main.js')

module.exports = {
    entry: [
        'babel-polyfill',
         SRC_FILE_JS_APP
    ],
    output: {
        path: DIST_FOLDER,
     //   publicPath: '/public/',
     //   filename: DIST_FILE_JS_BUNDLE,
     //   sourceMapFilename: 'sourcemaps/[file].map',
        filename: '[name].js', // this works better for hot reload
        chunkFilename: '[name].js'
    },
    resolve: {
        modules: ['node_modules', APP_FOLDER],
        extensions: ['.js', '.json', '.css', '.scss', '.vue'],
        descriptionFiles: ['package.json'],
        alias: {
            'vue$': 'vue/dist/vue.esm.js'
        }
    },
    module: {
        rules: [
            {
                test: /\.vue$/,
                loader: 'vue-loader',
                options: {
                    loaders: {

                    }
                    // othe vue-loader options go here
                }
            },
            {
                test: /\.js$/,
                loader: 'babel-loader',
                include: [APP_FOLDER],
                exclude: /(node_modules)/,
                options: {
                    cacheDirectory: true,
                    presets: [              
                        "vue-app",
                        "stage-2"
                    ],
                    plugins: [
                        "transform-runtime",
                    ]
                },
            },
            {
                test: /\.(png|jpe?g|gif|svg)$/,
                loader: 'file-loader',
                options: {
                    name: '[name].[ext]?[hash]'
                }
            },
            {
                test: /\.(css|scss)$/,
                use: ExtractTextPlugin.extract({
                    fallback: 'style-loader/url!file-loader',
                    use: ['css-loader', 'sass-loader'],
                    publicPath: DIST_FOLDER_STYLE,
                }),                
            },
            {
                test: /\.(eot|svg|ttf|woff|woff2)(\?\S*)?$/,
                loader: 'file-loader'
            }
        ]
    },
    devServer: {
        historyApiFallback: true,
        noInfo: true
    },
    performance: {
        hints: false
    },
    devtool: DEBUG ? 'source-map' : '',
    context: __dirname,
    target: 'web',
    plugins: 
        DEBUG ?
        [
            new ExtractTextPlugin({
                filename: DIST_FILE_CSS_BUNDLE,
                disable: false,
                allChunks: true,
            }),
            new WebpackNotifierPlugin({
                title: 'Anitoon Frontend Devmode',
                
                contentImage: path.join(__dirname, 'logo.png'),
                excludeWarnings: false,
                alwaysNotify: true,
                skipFirstNotification: false
            }),
        ]:
        [
            new webpack.optimize.ModuleConcatenationPlugin(),
            new webpack.DefinePlugin({
                'process.env': {
                    NODE_ENV: JSON.stringify('production'),
                },
            }),
            new webpack.optimize.OccurrenceOrderPlugin(),
            new webpack.optimize.UglifyJsPlugin({
                sourceMap: false,
                mangle: false,
                compress: {
                    warnings: false,
                }
            }),
            new ExtractTextPlugin({
                filename: DIST_FILE_CSS_BUNDLE,
                disable: false,
                allChunks: true,
            }),            
            new OptimizeCssAssetsPlugin({
                //assetNameRegExp: DIST_FILE_CSS_BUNDLE_NAME,
                assetNameRegExp: /\.optimize\.css$/g,
                cssProcessor: require('cssnano'),
                cssProcessorOptions: {
                    safe: true,
                    discardComments: { removeAll: true},
                },
                canPrint: true,
            }),
            new webpack.LoaderOptionsPlugin({
                minimize: true
            }),
            new webpack.DllReferencePlugin({
                context: path.join(__dirname, 'src'),
                manifest: require(`./dll/vendor-manifest.json`)
            }),
            new WebpackNotifierPlugin({
                title: 'Anitoon Frontend Production',
                contentImage: path.join(__dirname, 'logo.png'),
                excludeWarnings: false,
                alwaysNotify: true,
                skipFirstNotification: false
            }),
        ],
    cache: true,
    watchOptions: {
        aggregateTimeout: 1000,
        poll: true,
    },
    devServer: {
        contentBase: DIST_FOLDER,
        compress: true,
        inline: true,
        port: 8080,
    },
};

/*if (process.env.NODE_ENV === 'production'){
    module.exports.devtool = '#source-map'
    module.exports.plugins = (module.exports.plugins || []).concat([
        new webpack.optimize.ModuleConcatenationPlugin(),
        new webpack.DefinePlugin({
            'process.env': {
                NODE_ENV: '"production"'
            }
        }),
        new webpack.optimize.UglifyJsPlugin({
            sourceMap: true,
            compress: {
                warnings: false
            }
        }),
        new webpack.LoaderOptionsPlugin({
            minimize: true
        })
    ])
}*/