chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect
Loudbot = require('../src/loudbot')

describe 'Loudbot', ->
  beforeEach ->
    @brain = 
      get: sinon.spy()
      set: sinon.spy()
      on: sinon.spy()
    @sut = new Loudbot(@brain)

  describe 'remember', ->
    beforeEach ->
      @sut.remember 'LOUD TEXT'

    it 'adds to array', ->
      expect('LOUD TEXT' in @sut.louds).to.be.true

    it 'saves in brain', ->
      expect(@brain.set).to.have.been.calledWith('LOUDS', @sut.louds)

    it 'does not save duplicate louds', ->
      loudCount = @sut.louds.length
      @sut.remember 'LOUD TEXT'
      expect(@sut.louds.length).to.equal(loudCount)

  describe 'constructor', ->
    it 'initializes louds array', ->
      expect(@sut.louds).to.be.array

  describe 'isLoud', -> 
    it 'has caps', ->
      expect(@sut.isLoud('WHY IS EVERYONE YELLING')).to.be.true
      expect(@sut.isLoud('i do not know')).to.be.false

    it 'allows punctuation', ->
      expect(@sut.isLoud('PUNCTUATION TOO?!?.?;?')).to.be.true

    it 'is long enough', ->
      expect(@sut.isLoud('LOL')).to.be.false

    it 'has a letter', ->
      expect(@sut.isLoud('?????')).to.be.false

    it 'has enough letters', ->
      expect(@sut.isLoud('??? HI ???')).to.be.false

