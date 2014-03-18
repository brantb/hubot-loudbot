# Description
#   A LOUDBOT SCRIPT FOR HUBOT
#
# Dependencies:
#   NONE
#
# Configuration:
#   NONE
#
# Author:
#   brantb

Loudbot = require ('./loudbot')

module.exports = (robot) ->
  loudbot = new Loudbot(robot.brain)
  console.log "LOUDBOT INITIALIZED WITH #{LOUDBOT.louds.length} LOUDS"

  robot.hear /.*/, (msg) ->
    text = msg.match[0]
    if loudbot.isLoud text
      msg.send msg.random loudbot.louds
      loudbot.remember text
