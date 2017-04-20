import fs          from 'fs'
import path        from 'path'

import findCoffee  from 'find-coffee'
import sake        from 'sake-core'
import yargs       from 'yargs'
import {transform} from 'reify/lib/compiler'

import {findSakefile, missingTask, printTasks} from './utils'
import {version} from '../package.json'


# Attempt to load cached, pre-compiled Sakefile
loadCached = (dir, file) ->
  cacheFile = path.join dir, '.sake', 'Sakefile.js'

  try
    cached = fs.statSync cacheFile
    source = fs.statSync path.join dir, file
  catch err
    return false if err.code == 'ENOENT'
    throw err

  if cached.mtime > source.mtime
    require cacheFile
    true
  else
    false


loadCakefile = (dir, file) ->
  # Find local copy of CoffeeScript
  coffee = findCoffee()

  # Register .coffee extension
  coffee.register()

  # Compile and run Cakefile
  coffee.run fs.readFileSync(file).toString(), filename: file


loadSakefile = (dir, file) ->
  try
    # Require Sakefile directly
    require path.join dir, file
  catch err
    throw err unless (path.extname file) == ''
    throw err unless err.constructor.name == 'SyntaxError'
    loadCakefile dir, file


loadSakefileTs = (dir, file) ->
  # Write straight to cache
  exec.sync 'tsc --outFile .sake/Sakefile.js Sakefile.ts'
  loadCached dir, file


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

  # Print Sake version
  if argv.version or argv.v and not argv._.length
    console.log "#{version} (core: #{sake.version})"
    process.exit 0

  # Install Sake globals
  sake.install()

  # Try and use cached, compiled Sakefile
  unless loadCached dir, file

    # Fallback to appropriate loader
    switch file
      when 'Cakefile'
        loadCakefile dir, file
      when 'Sakefile', 'Sakefile.js'
        loadSakefile dir, file
      when 'Sakefile.ts'
        loadSakefileTs dir, file

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
