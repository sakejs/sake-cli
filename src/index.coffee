import fs       from 'fs'
import path     from 'path'
import minimist from 'minimist'

import {install}      from 'sake-core'
import registerCoffee from './utils'

registerCoffee() # Register .coffee extension

# Display the list of Cake tasks in a format similar to `rake -T`
printTasks = ->
  relative = path.relative or path.resolve
  cakefilePath = path.join relative(__originalDirname, process.cwd()), 'Cakefile'
  console.log "#{cakefilePath} defines the following tasks:\n"
  for name, task of tasks
    spaces = 20 - name.length
    spaces = if spaces > 0 then Array(spaces + 1).join(' ') else ''
    desc   = if task.description then "# #{task.description}" else ''
    console.log "cake #{name}#{spaces} #{desc}"
  console.log oparse.help() if switches.length

# Print an error and exit when attempting to use an invalid task/option.
fatalError = (message) ->
  console.error message + '\n'
  console.log 'To see a list of all tasks/options, run "cake"'
  process.exit 1

missingTask = (task) -> fatalError "No such task: #{task}"

# When `cake` is invoked, search in the current and all parent directories
# to find the relevant Cakefile.
cakefileDirectory = (dir) ->
  return dir if fs.existsSync path.join dir, 'Cakefile'
  parent = path.normalize path.join dir, '..'
  return cakefileDirectory parent unless parent is dir
  throw new Error "Cakefile not found in #{process.cwd()}"
