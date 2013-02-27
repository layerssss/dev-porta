fs = require 'fs'
http = require 'http'
path = require 'path'
express = require 'express'
{
  spawn
  exec
} = require 'child_process'

allocatePort = (cb)->
  s = http.createServer ->
  await s.listen defer e
  return cb e if e
  port = s.address().port
  s.close()
  cb null, port

module.exports = ()->
  throw new Error 'You can do nothing without a $HOME' unless process.env.HOME
  PROCESSPATH = path.join process.env.HOME, '.dev-porta-process'
  if !fs.existsSync PROCESSPATH
    fs.mkdirSync PROCESSPATH
  cfg = null
  if fs.existsSync path.resolve './.dev-porta.json'
    cfg = require path.resolve './.dev-porta.json'

  if !cfg
    console.log "this is a portal!"
    app = express()
    app.set 'views', path.join __dirname, 'views'
    app.set 'view engine', 'jade'
    app.get '/', (req, res)->
      data = []
      for file in fs.readdirSync PROCESSPATH
        continue unless file.match /\.json/
        data.push
          name: file.substring 0, file.length - '.json'.length
          ports: JSON.parse fs.readFileSync (path.join PROCESSPATH, file), 'utf8'
      res.render 'porta', data: data, host: req.host

    server = http.createServer app
    server.listen (Number process.env.PORT||80), ->
      console.log "porta opened at #{server.address().port}"
  else
    console.log "this is a process!"
    processName = "#{process.pid}-#{path.basename path.resolve '.'}"
    processPorts = []
    for portName, portEnv of cfg.ports
      await allocatePort defer e, port
      processPorts.push
        name: portName
        env: portEnv
        port: port
    fs.writeFileSync (path.join PROCESSPATH, processName + '.json'), (JSON.stringify processPorts), 'utf8'

    process.on 'exit', ->
      fs.unlinkSync (path.join PROCESSPATH, processName + '.json')
      console.log "process exiting.."
    process.on 'SIGINT', ->
      process.exit -1
    process.on 'SIGTERM', ->
      process.exit -1

    env = {}
    env[k] = v for k, v of process.env
    for port in processPorts
      env[port.env] = port.port
    p = spawn cfg.command, (Array cfg.args), env: env
    p.stdout.pipe process.stdout, end: false
    p.stderr.pipe process.stderr, end: false
    process.stdin.pipe p.stdin, end: false
    await p.on 'exit', defer code
    console.log "#{cfg.command} exited with #{code}"

    



    
