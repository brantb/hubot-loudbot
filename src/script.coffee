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
  isForRobot = (message) ->
    message.toUpperCase().indexOf(robot.name.toUpperCase()) == 0

  loudbot = new Loudbot(robot.brain)
  console.log "LOUDBOT INITIALIZED"

  robot.hear /.*/, (msg) ->
    text = msg.match[0]
    if loudbot.isLoud(text)
      msg.send msg.random loudbot.louds
      if !isForRobot(text)
        loudbot.remember text

  robot.respond /forget loud (.*)/i, (msg) ->
    loudbot.forget msg.match[1]
