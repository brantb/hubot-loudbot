_ = require 'lodash'

loudRegex = new RegExp(/^[A-Z\s]+$/)

class Loudbot
  constructor: (@brain) ->
    @loaded = false
    @louds = []
    @brain.on 'loaded', =>
      if not @loaded
        @loaded = true

        # pull louds from brain
        loadedLouds = @brain.get('LOUDS') or []
        console.log "LOADED #{loadedLouds.length} LOUDS FROM BRAIN"

        # seed louds if brain was empty
        if not loadedLouds.length
          console.log 'POPULATING LOUDS FROM INITIAL SEED'
          loadedLouds = @getSeed()
        
        @louds = _.union(@louds, loadedLouds)
        @saveLouds()

  getSeed: ->
    require('./seed').slice()

  isLoud: (text) ->
    loudRegex.test(text) and text.length > 6

  remember: (text) ->
    if text not in @louds
      console.log "REMEMBERING NEW LOUD: #{text}"
      @louds.push text
      @saveLouds()

  saveLouds: ->
    @brain.set 'LOUDS', @louds
    @brain.save()

module.exports = Loudbot
