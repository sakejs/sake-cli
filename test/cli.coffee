describe 'bin/sake', ->
  it 'should show normal sake usage', ->
    {stdout} = yield run ''
    stdout.lines[0].should.equal 'Sakefile defines the following tasks:'

  it 'should fail to run non-existent task', ->
    {status} = yield run 'non-existent-task'
    status.should.eq 1

