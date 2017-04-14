import fs          from 'fs'
import findCoffee  from 'find-coffee'
import sake        from 'sake-core'
import yargs       from 'yargs'
import {transform} from 'reify/lib/compiler'

import {findSakefile, missingTask, printTasks} from './utils'


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
  argv = yargs.argv
  argv.arguments = argv._  # For backwards compatibility with cake
  tasks = argv._.slice 0   # Create a copy of tasks to execute

  if argv.debug
    process.env.VERBOSE = true
    console.log argv

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
  for task in tasks
    unless sake.tasks[task]?
      missingTask task

  # Let's drink
  sake.serial tasks, argv, (err) ->
    console.error err if err?
    process.exit 1
