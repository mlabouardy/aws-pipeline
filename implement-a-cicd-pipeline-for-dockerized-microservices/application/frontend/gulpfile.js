const gulp = require('gulp');
const webserver = require('gulp-webserver');
const replace = require('gulp-replace');

gulp.task('replace', () => {
  gulp.src('index.html')
    .pipe(replace('API_URL', 'http://localhost:3000'))
    .pipe(gulp.dest('build/'))
})
 
gulp.task('webserver', () => {
  gulp.src('build')
    .pipe(webserver({
      livereload: true,
      directoryListing: false,
      open: true
    }));
});