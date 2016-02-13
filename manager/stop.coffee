{spawnSync} = require 'child_process'
fs = require 'fs'

if process.argv.length <= 2
  console.log """
  Usage: coffee stop.coffee INSTANCE
  """
  process.exit 1

instance = process.argv[2]

root = "C:\\semanager\\worlds\\#{instance}"
pidFile = "#{root}\\server.pid"

attemptsBeforeForce = 7
attemptsBeforeQuiting = 10
waitBetweenAttempts = 10


pid = fs.readFileSync pidFile, "utf-8"
pid = pid.trim()
console.log "Found PID: #{pid}"

waits = 0
attempts = 0

kill = (force=false) ->
  try
    process.kill pid, 0
  catch error
    console.log "Process is not running, exiting"
    process.exit()

  console.log "Process is running, running taskkill"
  args = ["/PID", pid]
  if force
    args.push "/F"

  console.log "Spawning taskkill with args:", require("util").inspect args
  out = spawnSync "taskkill", args
  console.log "STDOUT: #{out.stdout}"
  console.log "STDERR: #{out.stderr}" if out.stderr
  attempts += 1

wait = ->
  try
    process.kill pid, 0
  catch error
    console.log "Process exited"
    process.exit()

  if attempts >= attemptsBeforeQuiting
    console.log "Could not forcekill process, giving up"
    process.exit 2

  else if attempts is attemptsBeforeForce
    waits += 1
    setTimeout wait, 1000
    if waits >= waitBetweenAttempts
      attempts += 1
    return

  else if attempts > attemptsBeforeForce
    console.log "Could not gracefully shutdown after #{attempts} attempts, force killing"
    kill(true)
    waits = 0
    setTimeout wait, 3000
    return

  else if waits >= waitBetweenAttempts
    console.log "More than #{waits} seconds since last kill, running again"
    kill()
    waits = 0
    setTimeout wait, 1000
    return

  console.log "Process is still running, waiting"
  waits += 1
  setTimeout wait, 1000

kill()
setTimeout wait, 5000
