use 'sake-bundle'
use 'sake-outdated'
use 'sake-publish'
use 'sake-test'
use 'sake-version'

task 'build', 'build project', ->
  b = new Bundle
    entry:    'src/cli.coffee'
    commonjs: true
    compilers:
      coffee: version: 1

  Promise.all [
    b.write format:  'cli'
    b.write formats: ['cjs', 'es']
  ]
