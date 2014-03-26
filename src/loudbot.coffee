_ = require 'lodash'

class Loudbot
  constructor: (@brain) ->
    @louds = []
    @brain.on 'loaded', ->
      loadedLouds = @brain.get('LOUDS') or []
      console.log "LOADED #{loadedLouds.length} LOUDS FROM BRAIN"
      if not loadedLouds.length
        console.log 'POPULATING LOUDS FROM INITIAL SEED'
        loadedLouds = @getSeed()
      @louds = _.union(@louds, loadedLouds)

  getSeed: ->
    require('./seed').slice()

  isUpperCase: (text) ->
    text == text.toUpperCase() and text != text.toLowerCase()

  numLettersIn: (text) ->
    text.match(/[A-Z]/g).length

  isLoud: (text) ->
    @isUpperCase(text) && @numLettersIn(text) > 3

  remember: (text) ->
    if text not in @louds
      @louds.push text
      @brain.set 'LOUDS', @louds

module.exports = Loudbot
