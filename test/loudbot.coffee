chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'
chai.use require 'chai-things'

expect = chai.expect
Loudbot = require('../src/loudbot')

getBrain = ->
  # this is almost certainly the wrong way to mock thlngs
  brain = {
    get: sinon.stub()
    set: sinon.stub()
    on: sinon.stub()
    save: sinon.stub()
  }

getLoudbot = ->
  new Loudbot(getBrain())

# These should be chai extensions but I'll be damned if I know how
# to make that happen
expectLoud = (text) ->
  bot = getLoudbot()
  expect(bot.isLoud(text)).to.be.true

expectNotLoud = (text) ->
  bot = getLoudbot()
  expect(bot.isLoud(text)).to.be.false

describe 'Loudbot', ->
  beforeEach ->
    @sut = getLoudbot()

  describe 'remember', ->
    beforeEach ->
      @sut.remember 'LOUD TEXT'

    it 'adds to array', ->
      expect('LOUD TEXT' in @sut.louds).to.be.true

    it 'saves in brain', ->
      expect(@sut.brain.set).to.have.been.calledWith('LOUDS', @sut.louds)
      expect(@sut.brain.save).to.have.been.called

    it 'does not save duplicate louds', ->
      loudCount = @sut.louds.length
      @sut.remember 'LOUD TEXT'
      expect(@sut.louds.length).to.equal(loudCount)

  describe 'forget', ->
    beforeEach ->
      @sut.remember 'LOUD TEXT'

    it 'removes text from louds array', ->
      @sut.forget 'LOUD TEXT'
      expect(@sut.louds).to.not.include 'LOUD TEXT'

    it 'saves louds in brain', ->
      @sut.forget 'LOUD TEXT'
      expect(@sut.brain.set).to.have.been.calledTwice
      expect(@sut.brain.set).to.have.always.calledWith('LOUDS', @sut.louds)

    it 'returns true if the loud was removed', ->
      result = @sut.forget 'LOUD TEXT'
      expect(result).to.be.true

    it 'returns false if no loud was removed', ->
      result = @sut.forget 'DOES NOT EXIST'
      expect(result).to.be.false

  describe 'constructor', ->
    it 'initializes louds array', ->
      expect(@sut.louds).to.be.array

  describe 'loadFromBrain', ->
    describe 'when there are louds in the brain', ->
      beforeEach ->
        mockLouds = ['EXPECTED LOUD', 'not expected']
        @sut.brain.get.returns mockLouds
        @sut.loadFromBrain()

      it 'loads louds from brain', ->
        expect(@sut.brain.get).to.have.been.calledWith 'LOUDS'
        expect(@sut.louds).to.include 'EXPECTED LOUD'

      it 'does not load text that isn\'t loud enough', ->
        expect(@sut.louds).to.not.include 'not expected'
        expect(@sut.louds.length).to.equal 1

    describe 'when there are no louds in the brain', ->
      beforeEach ->
        @sut.loadFromBrain()

      it 'uses the seed data', ->
        expect(@sut.louds).to.include 'SO\'S YOUR FACE'

  describe 'isLoud', -> 
    it 'is all caps', ->
      expectLoud 'WHY IS EVERYONE YELLING'
    
    it 'has no lower case characters', ->
      expectNotLoud 'I do not know'

    it 'allows punctuation', ->
      expectLoud 'AAA AAAAAAAAAAA!'

    it 'is long enough', ->
      expectNotLoud 'LOLOLO'
      expectLoud 'LONG CAT IS LONG'

    it 'is long enough when non-letters are removed', ->
      expectNotLoud 'LOLOLO123"%$!!!!!!'
      expectNotLoud 'WTB C# 5'
      expectLoud 'SHUT UP I\'M NOT OLD'
      expectLoud 'BLAME CANADA!'

    it 'is mostly letters', ->
      expectLoud '3 OUT OF 5 DENTISTS AGREE: BRUSH YOUR TEETH'
      expectNotLoud 'ABCDEFG 123'
      expectNotLoud '7DB3AFA6'
      expectNotLoud '??? HI ???'

    it 'is at least two words', ->
      expectLoud 'AAAAAAAAAA HHHHHHHH'
      expectNotLoud 'AAAAAAAAAAAAAHHHHHHHH'
      expectNotLoud ' AAAAAAAAAAAAAHHHHHHHH'


