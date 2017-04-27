export default transform = (code) ->
  babel     = require 'babel-core'
  esModules = require 'babel-plugin-transform-es2015-modules-commonjs'

  out = babel.transform code,
    plugins: [
      [esModules, loose: true]
    ]
  out.code
