chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'script', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()
      brain: 
        get: sinon.spy()
        on: sinon.spy()
    require('../src/script')(@robot)

  it 'hears all', ->
    expect(@robot.hear).to.have.been.calledWith(/.*/)

  it 'can forget louds', ->
    expect(@robot.respond).to.have.been.calledWith(/forget loud (.*)/i)
