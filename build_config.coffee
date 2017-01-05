path = require 'path'

config =
  port: 8000
  src: path.resolve './src/app'
  static: path.resolve './src/static'
  dist: path.resolve './dist'
  node: path.resolve './node_modules'
  main: 'main.js'
  entry: [path.resolve './src/app/index.coffee']
  watch:
    src: path.resolve './src/app/**/*.coffee'

module.exports = config: config
