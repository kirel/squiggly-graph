var gulp = require('gulp');
var gutil = require('gulp-util');
var rename = require("gulp-rename");
var browserify = require('gulp-browserify');

var paths = {
  scripts: ['src/coffee/**/*.coffee']
};

gulp.task('scripts', function() {
  gulp.src('src/coffee/app.coffee', { read: false })
  .pipe(browserify({
    transform: ['coffeeify', 'debowerify'],
    extensions: ['.coffee'],
    debug: true
  }))
  .pipe(rename('app.js'))
  .pipe(gulp.dest('./js'))
});

gulp.task('watch', function () {
  gulp.watch(paths.scripts, ['scripts']);
});

gulp.task('default', ['scripts', 'watch']);
