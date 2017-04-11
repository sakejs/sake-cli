import path from 'path'

# Register .coffee extension so CoffeeScript files can be required normally
export registerCoffee = ->
  try
    require 'coffeescript/register'
    return true
  catch err

  try
    require 'coffee-script/register'
    true
  catch err
    false

# Ensure local node_modules bin is on the front of $PATH
export preferLocalModules = ->
  binPath = path.join process.cwd(), 'node_modules/', '.bin'
  process.env.PATH = ([binPath].concat process.env.PATH.split ':').join ':'
