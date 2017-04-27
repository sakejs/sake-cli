export default transform = (code) ->
  acorn     = require 'acorn'
  escodegen = require 'escodegen'
  reify     = require 'reify/lib/transform'

  ast = acorn.parse code
  reify ast, ast: true
  escodegen.generate ast
