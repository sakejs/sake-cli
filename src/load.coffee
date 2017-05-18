import fs   from 'fs'
import path from 'path'

import findCoffee from 'find-coffee'
import cache from './cache'

# Load Cakefile
loadCakefile = (dir, file) ->
  # Try to load from cache
  return if cache.load dir, file

  # Find local copy of CoffeeScript
  coffee = findCoffee()

  # Register .coffee extension
  coffee.register()

  # Compile Cakefile
  code = fs.readFileSync file, 'utf8'
  js   = coffee.compile code,
    bare:      true
    filename:  file
    sourceMap: false

  # Write to cache and try to load
  cache.write dir, js
  cache.require dir

# Load Sakefile
loadSakefile = (dir, file) ->
  # Try to load from cache
  return if cache.load dir, file

  try
    code = fs.readFileSync file, 'utf8'
    cache.write dir, code
    cache.require dir
  catch err
    throw err unless (path.extname file)  == ''
    throw err unless err.constructor.name == 'SyntaxError'
    loadCakefile dir, file


# Load Sakefile.ts
loadSakefileTs = (dir, file) ->
  # Try to load from cache
  return if cache.load dir, file

  # Write straight to cache
  exec.sync "tsc --types sake-core --outFile .sake/Sakefile.js Sakefile.ts"
  cache.require dir


export default load =
  Cakefile:   loadCakefile
  Sakefile:   loadSakefile
  SakefileTs: loadSakefileTs
