{spawn} = require 'child_process'
path = require 'path'
fs = require 'fs'

if process.argv.length <= 2
  console.log """
  Usage: coffee stop.coffee INSTANCE
  """
  process.exit 1

instance = process.argv[2]

root = "C:\\semanager\\worlds\\#{instance}"
seExe = "#{root}\\server\\DedicatedServer64\\SpaceEngineersDedicated.exe"
sePath = "#{root}\\data"
outFile = "#{root}\\out.log"
errFile = "#{root}\\err.log"
pidFile = "#{root}\\server.pid"
logRotate = 10 # number of logs to keep

# Rotate Logs
rotate = ->
  try
    fs.unlink path.join(sePath, "SpaceEngineersDedicated.#{logRotate}.log")
  catch error
    console.log "Could not remove last log", error

  for i in [logRotate...1]
    try
      fs.renameSync path.join(sePath, "SpaceEngineersDedicated.#{i-1}.log"),
        path.join(sePath, "SpaceEngineersDedicated.#{i}.log")
      console.log "Rotated #{i}"
    catch error
      console.log "Could not rotate #{i}", error

  try
    fs.renameSync path.join(sePath, "SpaceEngineersDedicated.log"),
      path.join(sePath, "SpaceEngineersDedicated.1.log")
  catch error
    console.log "Could not rotate most recent log", error

rotate()

out = fs.openSync(outFile, 'a')
err = fs.openSync(errFile, 'a')

seArgs = ['-noconsole', '-path', sePath]
seOpts =
  cwd: sePath
  detached: true
  stdio: ['ignore', out, err]

se = spawn seExe, seArgs, seOpts

fs.writeFileSync pidFile, se.pid.toString()
console.log "Started child with PID #{se.pid}"
se.unref()
process.exit()
