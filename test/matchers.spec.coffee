_         = require 'underscore'
should    = require 'should'
matchers  = require '../src/matchers'

describe 'matchers', ->

  m = matchers
  path = 'PATH'

  describe 'string', ->
    
    it 'valid type',            -> should.not.exist m.string('hi')
    it 'invalid type',          -> m.string(3).should.eql 'should be a string'

  describe 'number', ->
    
    it 'valid integer',         -> should.not.exist m.number(3)
    it 'valid float',           -> should.not.exist m.number(3.2)
    it 'invalid',               -> m.number('foo').should.eql 'should be a number'

  describe 'boolean', ->
    
    it 'valid (true)',          -> should.not.exist m.boolean(true)
    it 'valid (false)',         -> should.not.exist m.boolean(false)
    it 'invalid bool',          -> m.boolean('foo').should.eql 'should be a boolean'

  describe 'ip', ->
    
    it 'valid (1 digit)',       -> should.not.exist m.ip('0.0.0.0')
    it 'valid (3 digit2)',      -> should.not.exist m.ip('255.255.255.255')
    it 'invalid (not string)',  -> m.ip(10).should.eql 'should be an IP'
    it 'invalid (format)',      -> m.ip('10.hello.3').should.eql 'should be an IP'

  describe 'host', ->
    
    it 'valid (ip)',            -> should.not.exist m.host('10.0.13.6')
    it 'valid (hostname 1)',    -> should.not.exist m.host('my.long.host.name.local')
    it 'valid (hostname 2)',    -> should.not.exist m.host('with.valid987.digits-and-dashes')
    it 'invalid (not string)',  -> m.host(10).should.eql 'should be a host'
    it 'invalid (format 1)',    -> m.host('hey..cool..host').should.eql 'should be a host'
    it 'invalid (format 2)',    -> m.host('funny!characters~').should.eql 'should be a host'

  describe 'url', ->
    
    it 'valid (http)',          -> should.not.exist m.url('http://www.google.com')
    it 'valid (any schema)',    -> should.not.exist m.url('postgres://host/database')
    it 'valid (path+query)',    -> should.not.exist m.url('http://www.google.com/path/hello%20world?query+string')
    it 'valid (auth)',          -> should.not.exist m.url('http://user:pass@server')
    it 'invalid (not string)',  -> m.url(3).should.eql 'should be a URL'
    it 'invalid (format)',      -> m.url('almost/a/url').should.eql 'should be a URL'

  describe 'file', ->
    
    it 'exists',                -> should.not.exist m.file('package.json')
    it 'doest not exist',       -> m.file('package.something').should.eql 'should be an existing file path'

  describe 'money', ->
    
    it 'valid (2dp)',           -> should.not.exist m.money('$12.00')
    it 'valid (1dp)',           -> should.not.exist m.money('$12.5')
    it 'valid (0dp)',           -> should.not.exist m.money('$12')
    it 'invalid (not string)',  -> m.money(12).should.eql 'should be a dollar amount'
    it 'invalid (3dp)',         -> m.money('$12.500').should.eql 'should be a dollar amount'



