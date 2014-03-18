class Loudbot
  constructor: (@brain) ->
    @louds = @brain.get('LOUDS') or @getSeed()

  getSeed: ->
    require('./seed')
    
  isUpperCase: (text) ->
    text == text.toUpperCase() and text != text.toLowerCase()

  numLettersIn: (text) ->
    text.match(/[A-Z]/g).length

  isLoud: (text) ->
    @isUpperCase(text) && @numLettersIn(text) > 3

  remember: (text) ->
    @louds.push text
    @brain.set 'LOUDS', @louds

module.exports = Loudbot
