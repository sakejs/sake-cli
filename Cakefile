use 'sake-bundle'
use 'sake-publish'
use 'sake-test'
use 'sake-version'
use 'sake-outdated'

task 'build', 'Build project, '->
  bundle.write
    entry:  'src/index.coffee'
    format: 'cli'
    compilers:
      coffee:
        version: 1
