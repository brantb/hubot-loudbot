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
  isForRobot = (robotName, message) ->
    robotName and message.indexOf(robotName) == 0

  loudbot = new Loudbot(robot.brain)
  console.log "LOUDBOT INITIALIZED"

  robot.hear /.*/, (msg) ->
    text = msg.match[0]
    if !isForRobot(robot.name, text) and loudbot.isLoud(text)
      msg.send msg.random loudbot.louds
      loudbot.remember text
  
  robot.respond /forget loud (.*)/i, (msg) ->
    loudbot.forget msg.match[0]
