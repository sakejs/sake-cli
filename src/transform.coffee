export default transform = (code) ->
  out = require('babel-core').transform code,
    plugins: [
      ['transform-es2015-modules-commonjs', interop: false]
    ]
  out.code
