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

options = {
  profanity_filter: (process.env.HUBOT_LOUDBOT_PROFANITY_FILTER == 'true')
}

module.exports = (robot) ->

  loudbot = new Loudbot(robot.brain, options)
  console.log "LOUDBOT INITIALIZED"

  robot.hear /.*/, (msg) ->
    text = msg.match[0]
    if loudbot.isLoud(text)
      msg.send loudbot.randomLoud
      loudbot.remember text

  robot.respond /forget loud (.*)/i, (msg) ->
    forgotten = loudbot.forget msg.match[1]
    if forgotten
      msg.send "OK"
    else
      msg.send "I'VE NEVER HEARD THAT"
