module.exports = function (broccoli) {
  var filterCoffeeScript = require('broccoli-coffee')
  var compileSass = require('broccoli-sass')
  // var compileES6 = require('broccoli-es6-concatenator')

  html = broccoli.makeTree('public')

  var sass = broccoli.makeTree('src/sass')
  var css = compileSass([sass], 'styles.sass', 'styles/styles.css')

  var vendor = broccoli.makeTree('vendor')
  var bower = broccoli.makeTree('bower_components')
  var coffee = broccoli.makeTree('src/coffee')
  var js = filterCoffeeScript(coffee)

  js = new broccoli.MergedTree([vendor, bower, js])

  // js = compileES6(js, {
  //   loaderFile: 'app.js',
  //   ignoredModules: [],
  //   inputFiles: [
  //     'app.js'
  //   ],
  //   legacyFilesToAppend: [],
  //   wrapInEval: false,
  //   outputFile: '/js/app.js'
  // })
  //
  var traceur = require('broccoli-traceur');
  // js = traceur(js);

  return [html, js, css]
}
