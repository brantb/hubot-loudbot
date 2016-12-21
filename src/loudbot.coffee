_ = require 'lodash'
removeAccents = require('./diacritics').removeDiacritics

class Loudbot
  constructor: (@brain) ->
    @loaded = false
    @louds = []
    @brain.on 'loaded', =>
      @loadFromBrain()

  loadFromBrain: ->
    if not @loaded
      @loaded = true

      # pull louds from brain
      loadedLouds = @brain.get('LOUDS') or []
      console.log "LOADED #{loadedLouds.length} LOUDS FROM BRAIN"

      # seed louds if brain was empty
      if not loadedLouds.length
        console.log 'POPULATING LOUDS FROM INITIAL SEED'
        loadedLouds = @getSeed()
      
      @louds = _(@louds)
        .union(loadedLouds)
        .filter((text) => @isLoud text)
        .value()
      @saveLouds()

  getSeed: ->
    require('./seed').slice()

  isUpperCase: (text) ->
    text == text.toUpperCase() and text != text.toLowerCase()

  numLettersIn: (text) ->
    text.match(/[A-Z]/g).length

  numberRatio: (text) ->
    letters = numLettersIn(text)
    @numLettersIn(text).length

  # louds must be:
  #  * uppercase (duh)
  #  * eight or more letters
  #  * at least 90% letters (not counting whitespace)
  #  * two or more words
  isLoud: (text) ->
    text = text.trim()
    text = removeAccents(text)
    isUpperCase = text == text.toUpperCase() and text != text.toLowerCase()
    numLetters = text.match(/[A-Z ]/g, "")?.length || 0
    ratio = numLetters / text.length
    numWords = text.split(' ').length
    isUpperCase and numLetters >= 8 and ratio >= 0.9 and numWords >= 2

  remember: (text) ->
    if text not in @louds
      console.log "REMEMBERING NEW LOUD: #{text}"
      @louds.push text
      @saveLouds()

  forget: (text) ->
    exists = text in @louds
    if text in @louds
      console.log "FORGETTING LOUD: #{text}"
      _.pull(@louds, text)
      @saveLouds()
    exists

  saveLouds: ->
    @brain.set 'LOUDS', @louds
    @brain.save()

module.exports = Loudbot
