import exec from 'executive'
import fs from 'fs'

command = 'npm install --dev sake-cli sake-bundle sake-outdated sake-publish sake-version'

export default init = ->
  # Copy over default Sakefile
  console.log 'cp Sakefile .'
  buf = fs.readFileSync __dirname + '/../templates/coffee/Sakefile'
  fs.writeFileSync 'Sakefile', buf

  # Install deps
  console.log command
  exec command
