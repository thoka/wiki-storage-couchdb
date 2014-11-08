path = require('path')
random = require('../node_modules/wiki-server/lib/random_id')
testid = random()

argv = require('../node_modules/wiki-server/lib/defaultargs.coffee')({data: path.join('/tmp', 'sfwtests', testid), root: '../node_modules/wiki-server/'})

try
  page = require('../lib/couchdb.js')(argv)
catch e
  console.log "Not Testing CouchDB integration: storage package not present"
  return

testpage = {title: 'Asdf'}

describe 'couchdb', ->
  describe '#page.put()', ->
    it 'should save a page', (done) ->
      page.put('asdf', testpage, (e) ->
        if e then throw e
        done()
      )
  describe '#page.get()', ->
    it 'should get a page if it exists', (done) ->
      page.get('asdf', (e, got) ->
        if e then throw e
        got.title.should.equal 'Asdf'
        done()
      )
    it 'should copy a page from default if nonexistant in db', (done) ->
      page.get('welcome-visitors', (e, got) ->
        if e then throw e
        got.title.should.equal 'Welcome Visitors'
        done()
      )
    it 'should create a page if it exists nowhere', (done) ->
      page.get(random(), (e, got) ->
        if e then throw e
        got.should.equal('Page not found')
        done()
      )