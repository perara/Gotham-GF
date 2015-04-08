module.exports = (grunt)->
  require('load-grunt-tasks') grunt

  grunt.initConfig

    browserify:
      dist:
        files:
          './dist/Gotham.js': './src/Gotham.coffee'
          './dist/Gotham-dep.js': './src/Dependencies/Dependencies.coffee'
        options:
          transform: ['coffeeify']

    uglify:
      dist:
        files:
          './dist/Gotham.min.js': './dist/Gotham.js'
          './dist/Gotham-dep.min.js': './dist/Gotham-dep.js'

    clean:
      dist:
        files: './dist/*.js'

  grunt.registerTask 'default', ['clean', 'browserify', 'uglify']
