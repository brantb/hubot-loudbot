repeat = require('repeat-string')
pattern = '@#$%!&?'
badWords = require('cuss')
badThreshold = 2

isBad = (word) ->
  w = badWords[word.toLowerCase()]
  w? and w >= badThreshold

grawlixify = (text) ->
  charsNeeded = Math.floor text.length / pattern.length
  extras = text.length % pattern.length
  repeat(pattern, charsNeeded) + pattern.slice(0, extras)

filter = (word) ->
  if isBad word
    grawlixify word
  else
    word

purify = (text) ->
  words = text.split ' '
  purified = for word in words
    filter word
  purified.join ' '

module.exports.purify = purify
