chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'script', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()
    @sut = require('../src/hello-world')(@robot)

    it 'remembers loud messages', ->
      #expect(@robot.hear).to.have.been.calledWith(/.*/)

describe 'Loudbot', ->
  beforeEach ->
    @brain = 
      get: sinon.spy()
      set: sinon.spy()
    Loudbot = require('../src/loudbot')
    @sut = new Loudbot(@brain)

  describe 'remember', ->
    beforeEach ->
      @sut.remember 'LOUD'

    it 'adds to array', ->
      expect(@sut.louds.indexOf('LOUD')).to.be.positive

    it 'saves in brain', ->
      expect(@brain.set).to.have.been.calledWith('LOUDS', @sut.louds)

  describe 'constructor', ->
    it 'gets louds from brain', ->
      expect(@brain.get).to.have.been.calledWith('LOUDS')

    it 'initializes louds with seed data', ->
      expect(@sut.louds).not.to.be.empty
      expect(@sut.louds.indexOf("SORRY")).to.be.positive

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


