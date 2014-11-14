//  Copyright (c) 2014 - 2016 William C Miller
 
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the Software
//  is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall 
//  be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
//  ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.

var gulp = require('gulp');
var coffee = require('gulp-coffee');
var coffeelint = require('gulp-coffeelint');
var concat = require('gulp-concat');
var compress = require('gulp-yuicompressor');
var sourcemaps = require('gulp-sourcemaps');
var jasmine = require('gulp-jasmine-phantom');
var plumber = require('gulp-plumber');
var del = require('del');
var order = require('gulp-order');

var paths = {
  vendor: 'src/vendor/*.js',
  spec: 'spec/*.coffee',
  src: 'src/lib/*.coffee',
  tmp: 'bin/tmp/*.coffee.js',
  dev: 'bin/dev/*.js'
};

var STATE_OK = 0,
    STATE_ERR = 1;

var state = STATE_OK;

function handleError (err) {
  console.log(err.toString());
  this.emit('end');
  state = STATE_ERR;
  setTimeout(function() {
    state = STATE_OK;
  }, 200)
}

gulp.task('clean', function(cb) {
  del(['bin'], cb);
});

gulp.task('compile', ['clean'], function() {
  if (state === STATE_OK) {
    return gulp.src(paths.src)
    	.pipe(plumber(handleError))
    	//.pipe(sourcemaps.init())
    	.pipe(coffeelint())
      .pipe(coffeelint.reporter())
    	.pipe(coffee())
      .pipe(concat('malefic.coffee.js'))
      //.pipe(sourcemaps.write())
      .pipe(gulp.dest('bin/tmp'));
  } else if (state === STATE_ERR) {
    console.log('State is "error" skipping...');
  }
});

gulp.task('compile:dev', ['compile'], function() {
  if (state === STATE_OK) {
    return gulp.src([paths.vendor, paths.tmp])
      .pipe(order([paths.vendor, paths.tmp], {base: './'}))
      .pipe(concat('malefic.js'))
      .pipe(gulp.dest('bin/dev'));
  } else if (state === STATE_ERR) {
    console.log('State is "error" skipping...');
  }
});

gulp.task('compile:release', ['compile:dev'], function() {
  if (state === STATE_OK) {
    return gulp.src(paths.dev)
    	.pipe(plumber(handleError))
      .pipe(compress({
        type: 'js'
      }))
      .pipe(concat('malefic.min.js'))
      .pipe(gulp.dest('bin/release'));
  } else if (state === STATE_ERR) {
    console.log('State is "error" skipping...');
  }
});

gulp.task('compile:spec', ['compile:release'], function() {
  if (state === STATE_OK) {
  	return gulp.src(paths.spec)
  		.pipe(plumber(handleError))
  		.pipe(coffeelint())
      .pipe(coffeelint.reporter())
    	.pipe(coffee())
    	.pipe(concat('malefic.spec.js'))
    	.pipe(gulp.dest('bin/spec'));
  } else if (state === STATE_ERR) {
    console.log('State is "error" skipping...');
  }
});

gulp.task('spec', ['compile:spec'], function() {
  if (state === STATE_OK) {
    return gulp.src(['bin/dev/malefic.js', 'bin/spec/malefic.spec.js'])
    	.pipe(jasmine({
    		integration: true
    	}));
  } else if (state === STATE_ERR) {
    console.log('State is "error" skipping...');
  }
});

gulp.task('watch', function() {
  gulp.watch('src/lib/*.coffee', ['spec']);
});

gulp.task('default', ['spec']);
