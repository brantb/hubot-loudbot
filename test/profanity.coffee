chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

sut = require('../src/profanity')

describe 'profanity filter', ->
  it 'sanitizes profanity', ->
    result = sut.purify 'wtf'
    expect(result).not.to.have.string 'wtf'

  it 'is case-insensitive', ->
    result = sut.purify 'uhhh WTF is this'
    expect(result).not.to.have.string 'WTF'

  it 'does not modify clean text', ->
    result = sut.purify 'WORDS WORDS WORDS'
    expect(result).to.have.string 'WORDS WORDS WORDS'
