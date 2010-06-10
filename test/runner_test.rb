require File.expand_path('../test_helper', __FILE__)

class RunnerTest < Test::Unit::TestCase
  include Rack::Test::Methods

  PAYLOAD = {
    'scm'     => 'git',
    'uri'     => 'git://github.com/svenfuchs/i18n',
    'branch'  => 'master',
    'commit'  => '25456ac13e5995b4a4f68dcf13d5ce95b1a687a7'
  }

  attr_reader :app

  def setup
    Bob.logger = Logger.new("/tmp/bob.log")
    Travis::Config.config = { 'name' => 'i18n', 'command' => 'rake' }
    @app = Travis::Runner.new
  end

  test 'can build' do
    result = "{\"status\":true,\"output\":\"output\",\"commit\":\"25456ac13e5995b4a4f68dcf13d5ce95b1a687a7\"}"
    builder = Bob::Builder.new('cmd')
    builder.expects(:build).returns([true, 'output'])
    Bob::Builder.expects(:new).returns(builder)

    post '/', :payload => PAYLOAD.to_json
    assert last_response.ok?
    assert_equal result, last_response.body
  end
end