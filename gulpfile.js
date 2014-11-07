// Gulpfile.js
//
//  William C Miller
//  Maleficjs Copyright (c) 2014
//

var gulp = require('gulp');
var coffee = require('gulp-coffee');
var coffeelint = require('gulp-coffeelint');
var concat = require('gulp-concat');
var uglify = require('gulp-uglify');
var sourcemaps = require('gulp-sourcemaps');
var jasmine = require('gulp-jasmine');
var jasminePhantomJs = require('gulp-jasmine2-phantomjs');
var jasminePh = require('gulp-jasmine-phantom');
var del = require('del');

var paths = {
  src: ['src/lib/*.coffee'],
  spec: ['spec/*.coffee']
};

gulp.task('clean', function(cb) {
  del(['bin'], cb);
});

gulp.task('compile:dev', ['clean'], function() {
  return gulp.src(paths.src)
  	.pipe(sourcemaps.init())
  	.pipe(coffeelint())
    .pipe(coffeelint.reporter())
  	.pipe(coffee())
    .pipe(concat('malefic.coffee.js'))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('bin/dev'));
});

gulp.task('compile:release', ['compile:dev'], function() {
  return gulp.src(paths.src)
  	.pipe(sourcemaps.init())
  	.pipe(coffeelint())
    .pipe(coffeelint.reporter())
  	.pipe(coffee())
    .pipe(uglify())
    .pipe(concat('malefic.coffee.min.js'))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('bin/release'));
});

gulp.task('compile:spec', ['compile:release'], function() {
	return gulp.src(paths.spec)
		.pipe(coffeelint())
    .pipe(coffeelint.reporter())
  	.pipe(coffee())
  	.pipe(concat('malefic.spec.coffee.js'))
  	.pipe(gulp.dest('bin/spec'));
});

gulp.task('spec', ['compile:spec'], function() {
	//return gulp.src('spec/runner.html')
  //.pipe(jasminePhantomJs());
  return gulp.src(['bin/dev/malefic.coffee.js', 'bin/spec/malefic.spec.coffee.js'])
  	.pipe(jasminePh({
  		integration: true
  	}));
});

gulp.task('watch', function() {
  gulp.watch('./src/lib/*.coffee', ['spec']);
});

//gulp.task('default', ['watch']);
