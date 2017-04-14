describe 'invoke (parallel)', ->
  it 'should invoke tasks in parallel', ->
    {stdout} = yield run 'parallel'
    stdout.should.eq '''
      delay:0
      delay:10
      delay:20
      parallel
      '''
