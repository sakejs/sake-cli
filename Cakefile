require 'shortcake'

use 'cake-bundle'
use 'cake-publish'
use 'cake-test'
use 'cake-version'

task 'build', 'Build module and bundled checkout.js', ->
  bundle.write
    entry:  'src/index.coffee'
    format: 'cli'
    compilers:
      coffee:
        version: 1
