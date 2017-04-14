# convenient for testing
Object.defineProperty String.prototype, 'lines',
  get: -> @split '\n'

path = require 'path'
exec = require('executive').quiet

# path to sake
cwd = __dirname
bin = require.resolve 'sake-cli/bin/sake'

# Helper to run sake in tests
run = (cmd) ->
  console.log bin, cmd
  p = exec "#{bin} #{cmd}", {cwd: cwd}
  p.then (res) ->
    res.stdout = res.stdout.trim()
    res.stderr = res.stdout.trim()
  p.catch (err) ->
    throw err

before -> global.run = run
