chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect
Loudbot = require('../src/loudbot')

describe 'Loudbot', ->
  beforeEach ->
    # this is almost certainly the wrong way to mock thlngs
    @brain = 
      get: sinon.spy()
      set: sinon.spy()
      on: sinon.spy()
      save: sinon.spy()
    @sut = new Loudbot(@brain)

  describe 'remember', ->
    beforeEach ->
      @sut.remember 'LOUD TEXT'

    it 'adds to array', ->
      expect('LOUD TEXT' in @sut.louds).to.be.true

    it 'saves in brain', ->
      expect(@brain.set).to.have.been.calledWith('LOUDS', @sut.louds)
      expect(@brain.save).to.have.been.called

    it 'does not save duplicate louds', ->
      loudCount = @sut.louds.length
      @sut.remember 'LOUD TEXT'
      expect(@sut.louds.length).to.equal(loudCount)

  describe 'forget', ->
    beforeEach ->
      @sut.remember 'LOUD TEXT'

    it 'removes text from louds array', ->
      @sut.forget 'LOUD TEXT'
      expect('LOUD TEXT' in @sut.louds).to.be.false

    it 'saves louds in brain', ->
      @sut.forget 'LOUD TEXT'
      expect(@brain.set).to.have.been.calledTwice
      expect(@brain.set).to.have.always.calledWith('LOUDS', @sut.louds)

    it 'returns true if the loud was removed', ->
      result = @sut.forget 'LOUD TEXT'
      expect(result).to.be.true

    it 'returns false if no loud was removed', ->
      result = @sut.forget 'DOES NOT EXIST'
      expect(result).to.be.false

  describe 'constructor', ->
    it 'initializes louds array', ->
      expect(@sut.louds).to.be.array

  describe 'isLoud', -> 
    it 'is all caps', ->
      expect(@sut.isLoud('WHY IS EVERYONE YELLING')).to.be.true
    
    it 'has no lower case characters', ->
      expect(@sut.isLoud('I do not know')).to.be.false

    it 'disallows punctuation', ->
      expect(@sut.isLoud('AAAAAAAAAAA!')).to.be.false

    it 'is long enough', ->
      expect(@sut.isLoud('LOLOLO')).to.be.false

    it 'has a letter', ->
      expect(@sut.isLoud('???? ????????')).to.be.false

    it 'has enough letters', ->
      expect(@sut.isLoud('??? HI ???')).to.be.false

    it 'has no numbers', ->
      expect(@sut.isLoud('ABCDEFG HIJKL MN123')).to.be.false

