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
  coffee.run fs.readFileSync(file).toString(), filename: file


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
  argv.arguments = argv._  # for backwards compatibility with cake

  # Install Sake globals
  sake.install()

  # Handle both Cakefiles and Sakefiles
  switch file
    when 'Cakefile'
      loadCakefile dir, file
    when 'Sakefile', 'Sakefile.js'
      loadSakefile dir, file

  # Bail if no tasks specified
  return printTasks dir, file unless argv._.length

  # Bail if missing task
  for task in argv._
    unless sake.tasks.has task
      missingTask task

  # Let's drink
  sake.serial argv._, argv, (err) ->
    console.log err if err?
