import fs    from 'fs'
import sake  from 'sake-core'
import yargs from 'yargs'

import cache from './cache'
import load  from './load'
import init  from './init'
import {findSakefile, missingTask, printTasks} from './utils'
import {version} from '../package.json'


# Run `sake`. Executes all of the tasks you pass, in order.  If no tasks are
# passed, print the help screen. Keep a reference to the original directory
# name, when running Cake tasks from subdirectories.
export default run = ->
  # Save record of original directory
  global.__originalDirname = fs.realpathSync '.'

  # Process arguments
  argv  = yargs.argv
  tasks = argv._.slice 0  # Create a copy of tasks to execute
  argv.arguments = argv._ # For backwards compatibility with cake

  if argv.debug
    process.env.VERBOSE = true

  # Print Sake version
  if argv.version or argv.v and not argv._.length
    console.log "#{version} (core: #{sake.version})"
    process.exit 0

  # Search for sakefile
  try
    {dir, file} = findSakefile __originalDirname
  catch err
    if tasks[0] == 'init'
      return init()
    else
      console.log(err.toString())
      process.exit 1

  # Change dir to match Sakefile location
  process.chdir dir

  # Install Sake globals
  sake.install()

  # Load Sakefile
  unless cache.load dir, file
    switch file
      when 'Cakefile'
        load.Cakefile dir, file
      when 'Sakefile', 'Sakefile.js'
        load.Sakefile dir, file
      when 'Sakefile.ts'
        load.SakefileTs dir, file

  # Bail if no tasks specified
  return printTasks dir, file unless argv._.length

  # Bail if missing task
  for task in tasks
    unless sake.tasks[task]?
      missingTask task

  # Let's drink
  sake.invoke tasks, argv, (err) ->
    if err?
      console.error err
      process.exit 1
