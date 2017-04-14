import fs          from 'fs'
import findCoffee  from 'find-coffee'
import minimist    from 'minimist'
import sake        from 'sake-core'
import {transform} from 'reify/lib/compiler'

import {findSakefile, printTasks} from './utils'


loadCakefile = (dir, file) ->
  # Find local copy of CoffeeScript
  coffee = findCoffee()

  # Register .coffee extension
  coffee.register()

  # Compile and run Cakefile
  CoffeeScript.run fs.readFileSync(file).toString(), filename: file


loadSakefile = (dir, file) ->
  # Require Sakefile directly
  require path.join dir, file


# Run `sake`. Executes all of the tasks you pass, in order.  If no tasks are
# passed, print the help screen. Keep a reference to the original directory
# name, when running Cake tasks from subdirectories.
export run = ->
  # Save record of original directory
  global.__originalDirname = fs.realpathSync '.'

  # Search for sakefile
  {dir, file} = findSakefile __originalDirname

  # Change dir to match Sakefile location
  process.chdir dir

  # Process arguments
  argv = minimist process.argv[2..]

  # Bail if no tasks specified
  return printTasks() unless argv._.length

  # Install Sake globals
  sake.install()

  # Handle both Cakefiles and Sakefiles
  switch file
    when 'Cakefile'
      loadCakefile dir, file
    when 'Sakefile', 'Sakefile.js'
      loadSakefile dir, file

  sake.invoke task for tasks in argv._
