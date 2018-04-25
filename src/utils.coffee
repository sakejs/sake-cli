import path from 'path'
import fs   from 'fs'

import isFunction from 'es-is/function'
import {options}  from 'sake-core'
import {tasks}    from 'sake-core'

# Ensure local node_modules bin is on the front of $PATH
export preferLocalModules = ->
  binPath = path.join process.cwd(), 'node_modules/', '.bin'
  process.env.PATH = ([binPath].concat process.env.PATH.split ':').join ':'

# When `sake` is invoked, search in the current and all parent directories
# to find the relevant Sakefile (or Cakefile).
export findSakefile = (dir) ->
  for file in ['Sakefile', 'Sakefile.js', 'Cakefile', 'Sakefile.ts']
    return file: file, dir: dir if fs.existsSync path.join dir, file

  # Recurse up the directory structure
  parent = path.normalize path.join dir, '..'
  return findSakefile parent unless parent is dir

  # We're at the top, bail
  throw new Error "Sakefile not found in #{process.cwd()}"

# Display the list of Cake tasks in a format similar to `rake -T`
export printTasks = (dir, file) ->
  relative = path.relative or path.resolve
  filePath = path.join relative(__originalDirname, process.cwd()), file

  console.log "#{filePath} defines the following tasks:\n"

  delete tasks.has

  names = Object.keys(tasks).sort()

  for name in names
    task   = tasks[name]
    spaces = 20 - name.length
    spaces = if spaces > 0 then Array(spaces + 1).join(' ') else ''
    desc   = if task.description then "# #{task.description}" else ''
    console.log "sake #{name}#{spaces} #{desc}"

  if Object.keys(options).length > 1
    console.log()
    for own k,v of options
      continue if isFunction v

      if v.flag?
        switches = "#{v.letter}, #{v.flag}"
      else
        switches = "#{v.letter}"
      spaces = 18 - switches.length
      spaces = if spaces > 0 then Array(spaces + 1).join(' ') else ''
      console.log "  #{switches}#{spaces} #{v.description ? ''}"

# Print an error and exit when attempting to use an invalid task/option.
export fatalError = (message) ->
  console.error message + '\n'
  console.log 'To see a list of all tasks/options, run "sake"'
  process.exit 1

export missingTask = (task) -> fatalError "No such task: #{task}"
