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

describe 'LOUDBOT', ->
  beforeEach ->
    @brain = 
      get: sinon.spy()
      set: sinon.spy()
    Loudbot = require('../src/LOUDBOT')
    @SUT = new Loudbot(@brain)

  describe 'REMEMBER', ->
    beforeEach ->
      @SUT.remember 'LOUD'

    it 'ADDS TO ARRAY', ->
      expect(@SUT.louds.indexOf('LOUD')).to.be.positive

    it 'SAVES IN BRAIN', ->
      expect(@brain.set).to.have.been.calledWith('LOUDS', @SUT.louds)

  describe 'CONSTRUCTOR', ->
    it 'GETS LOUDS FROM BRAIN', ->
      expect(@brain.get).to.have.been.calledWith('LOUDS')

    it 'USES SEED DATA TO INITIALIZE LOUDS', ->
      expect(@SUT.louds).not.to.be.empty
      expect(@SUT.louds.indexOf("SORRY")).to.be.positive

  describe 'ISLOUD', -> 
    it 'HAS CAPS', ->
      expect(@SUT.isLoud('WHY IS EVERYONE YELLING')).to.be.true
      expect(@SUT.isLoud('i do not know')).to.be.false

    it 'CAN HAVE PUNCTUATION', ->
      expect(@SUT.isLoud('PUNCTUATION TOO???????')).to.be.true

    it 'IS LONG ENOUGH', ->
      expect(@SUT.isLoud('LOL')).to.be.false

    it 'HAS A LETTER', ->
      expect(@SUT.isLoud('?????')).to.be.false

    it 'HAS ENOUGH LETTERS', ->
      expect(@SUT.isLoud('??? HI ???')).to.be.false


