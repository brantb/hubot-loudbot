# Description
#   A LOUDBOT SCRIPT FOR HUBOT
#
# Configuration:
#   NONE
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Brant Bobby[@<org>]

Loudbot = require ('./loudbot')

module.exports = (robot) ->
  loudbot = new Loudbot(robot.brain)
  console.log "LOUDBOT INITIALIZED WITH #{LOUDBOT.louds.length} LOUDS"

  robot.hear /.*/, (msg) ->
    text = msg.match[0]
    if loudbot.isLoud text
      msg.send msg.random loudbot.louds
      loudbot.remember text
