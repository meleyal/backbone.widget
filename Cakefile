{exec} = require 'child_process'

run = (cmd) ->
  cmd = exec cmd
  cmd.stderr.on 'data', (data) -> console.log data
  cmd.stdout.on 'data', (data) -> console.log data

task 'build', 'Build from src', ->
  run 'coffee --compile backbone.pluginView.coffee'

task 'watch', 'Watch src for changes', ->
  run 'coffee --watch --compile backbone.pluginView.coffee'

task 'test', 'Run jasmine specs', ->
  run 'jasmine-node --coffee test'
