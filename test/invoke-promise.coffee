describe 'invoke (promise)', ->
  it 'should invoke returned promises', ->
    {stdout} = yield run 'promise'
    stdout.should.eq 'delay:0'

  it 'should invoke nested promise tasks', ->
    {stdout} = yield run 'promise-nested'
    stdout.should.eq 'delay:0'

