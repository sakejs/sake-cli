use 'sake-bundle'
use 'sake-outdated'
use 'sake-publish'
use 'sake-test'
use 'sake-version'

task 'build', 'build project', ->
  bundle.write
    entry:  'src/index.coffee'
    format: 'cli'
    compilers:
      coffee: version: 1
