require File.expand_path('../test_helper', __FILE__)

class RunnerTest < Test::Unit::TestCase
  include Rack::Test::Methods

  attr_reader :app

  def setup
    Bob.logger = Logger.new("/tmp/bob.log")
    Travis::Config.config = { 'name' => 'i18n', 'command' => 'rake' }
    @app = Travis::Runner.new
    super
  end

  test 'can build' do
    builder = Bob::Builder.new('cmd')
    builder.expects(:build).returns([true, 'output'])
    Bob::Builder.expects(:new).returns(builder)

    post '/', :payload => GITHUB_PAYLOAD.to_json
    assert last_response.ok?
    assert_equal RUNNER_RESULT, JSON.parse(last_response.body)
  end
end