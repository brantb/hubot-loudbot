# Description
#   A LOUDBOT SCRIPT FOR HUBOT
#
# Dependencies:
#   NONE
#
# Configuration:
#   NONE
#
# Commands:
#   hubot forget loud <loud> - REMOVE LOUDBOT TEXT
# 
# Author:
#   brantb

Loudbot = require ('./loudbot')

module.exports = (robot) ->

  loudbot = new Loudbot(robot.brain)
  console.log "LOUDBOT INITIALIZED"

  robot.hear /.*/, (msg) ->
    text = msg.match[0]
    if loudbot.isLoud(text)
      msg.send msg.random loudbot.louds
      loudbot.remember text

  robot.respond /forget loud (.*)/i, (msg) ->
    forgotten = loudbot.forget msg.match[1]
    if forgotten
      msg.send "OK"
    else
      msg.send "I'VE NEVER HEARD THAT"
