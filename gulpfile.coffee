path = require 'path'
gulp = require 'gulp'
gutil = require 'gulp-util'
gwatch = require 'gulp-watch'
sourcemaps = require 'gulp-sourcemaps'
uglify = require 'gulp-uglify'
coffeelint = require 'gulp-coffeelint'
connect = require 'gulp-connect'
browserify = require 'browserify'
source = require 'vinyl-source-stream'
buffer = require 'vinyl-buffer'
rimraf = require 'rimraf'

{config} = require './build_config'

RUNNING_IN_DEBUG_MODE = process.env.NODE_ENV isnt 'production'

gulp.task 'clobber', (onComplete) -> rimraf config.node, onComplete
gulp.task 'clean', (onComplete) -> rimraf config.dist, onComplete

gulp.task 'lint', ->
  gulp.src "#{config.src}/*.coffee"
  .pipe coffeelint()
  .pipe coffeelint.reporter()

gulp.task 'compile', ->
  cfg =
    entries: config.entry
    debug: RUNNING_IN_DEBUG_MODE
    extensions: ['.coffee']
    transform: ['coffeeify']
  ugly =
    debug: RUNNING_IN_DEBUG_MODE
    options:
      sourceMap: true
  browserify cfg
  .bundle()
  .pipe source config.main
  .pipe buffer()
  .pipe sourcemaps.init loadMaps: true, debug: RUNNING_IN_DEBUG_MODE
  .pipe uglify ugly
  .pipe sourcemaps.write './'
  .pipe gulp.dest config.dist
  .on 'error', gutil.log

gulp.task 'static', ->
  gulp.src "#{config.static}/**/*.*"
  .pipe gulp.dest config.dist
  .on 'error', gutil.log

gulp.task 'serve', ->
  cfg =
    debug: RUNNING_IN_DEBUG_MODE
    port: config.port
    livereload: true
    root: config.dist
  connect.server cfg

gulp.task 'livereload', ->
  gulp.src config.dist
  .pipe gwatch config.dist
  .pipe connect.reload()

gulp.task 'build', ['lint', 'compile', 'static']

gulp.task 'watch', ->
  gulp.watch config.watch.src, ['lint', 'compile']
  gulp.watch "#{config.static}/**/*.*", ['static']

gulp.task 'default', ['build', 'serve', 'livereload', 'watch']
