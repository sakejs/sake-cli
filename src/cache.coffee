import fs   from  'fs'
import path from  'path'

import transform from './transform'


# Find local node_modules relative to current project
findNodeModules = (dir) ->
  while true
    p = (path.join dir, 'node_modules')
    if fs.existsSync p
      return p
    if dir == '/'
      throw new Error 'Unable to locate node_modules'
    dir = path.resolve path.join dir, '..'


# Path to cache directory
cacheDir  = (dir) ->
  path.join (findNodeModules dir), '.sake'


# Path to cache file
cachePath = (dir) ->
  path.join (cacheDir dir), 'Sakefile.js'


# Safely make directory
mkdirp = (dir) ->
  try
    fs.mkdirSync dir
  catch err
    throw err unless err.code == 'EEXIST'


# Read cache file
read = (dir) ->
  fs.readFileSync (cachePath dir), 'utf8'


# Read origin dir for cache file
readOrigin = (dir) ->
  try
    fs.readFileSync (path.join (cacheDir dir), 'origin'), 'utf8'
  catch err # Support older copies of sake
    dir


# Write cache file
write = (dir, code) ->
  mkdirp cacheDir dir
  transformed = transform code
  fs.writeFileSync (cachePath dir), transformed, 'utf8'
  fs.writeFileSync (path.join (cacheDir dir), 'origin'), dir, 'utf8'


# Require cached Sakefile such that require and other Node machinery work
requireCached = (dir) ->
  # Symlink cached Sakefile back into Sakefile dir
  tempFile  = path.resolve path.join dir, "__Sakefile.js"
  fs.linkSync (cachePath dir), tempFile

  try
    require tempFile     # Require cached Sakefile
  catch err

  fs.unlinkSync tempFile # Ensure link is cleaned up
  throw err if err?      # Throw if failed to require Sakefile


# Load cached Sakefile unless it's older than source or from different Sakefile
load = (dir, file) ->
  try
    cached = fs.statSync cachePath dir
    source = fs.statSync path.join dir, file
  catch err
    return false if err.code == 'ENOENT'
    throw err

  if cached.mtime > source.mtime and dir == (readOrigin dir)
    requireCached dir
    true
  else
    false


export default cache =
  load:    load
  write:   write
  require: requireCached
