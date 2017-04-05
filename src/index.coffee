import path from 'path'

cake = null

loadCake = (coffee) ->
  return if cake?

  cakePath = "#{coffee}/lib/#{coffee}/cake"
  try
    cake = require cakePath
  catch err
    nodePaths = ['', '/usr/local/lib/node_modules', '/usr/lib/node_modules']
    do nextCake = ->
      return unless nodePaths.length

      try
        cake = require path.join nodePaths.shift(), cakePath
      catch err
        unless err.code is 'MODULE_NOT_FOUND'
          throw err
        else
          nextCake()

loadCake coffee for coffee in ['coffeescript', 'coffee-script']

unless cake.run?
  console.error 'Unable to locate CoffeeScript, try: npm install -g coffeescript'
  process.exit 1

# Setup process.argv for cake. If first argument to cake looks like a task,
# move it to end of arguments so cake agrees.
if process.argv[2] and process.argv[2].charAt(0) isnt '-'
  process.argv.push process.argv.splice(2, 1)[0]

# Run cake!
try
  require 'sake-core/install'
  cake.run()
catch err
  # Hide ugly traceback on common error.
  if /Cakefile not found in/.test err.message
    console.error err.message
  else
    throw err
