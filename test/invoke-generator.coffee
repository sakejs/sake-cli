describe 'invoke (generator)', ->
  it 'should consume generator tasks completely', ->
    {stdout} = yield run 'gen'
    stdout.should.eq '''
      gen-1
      gen-2
      gen-3
      '''

  it 'should send back promise results to generator tasks', ->
    {stdout} = yield run 'gen-promise'
    stdout.should.eq '''
      promise-1
      promise-2
      promise-3
      '''

  it 'should support various promise libraries', ->
    {stdout} = yield run 'gen-mz'
    stdout.should.eq '''
      true
      false
      true
      false
      '''

    {stdout} = yield run 'gen-bluebird'
    stdout.should.eq '''
      does not exist
      exists
      does not exist
      exists
      '''
