require File.expand_path('../test_helper', __FILE__)

class ServerTest < Test::Unit::TestCase
  include Rack::Test::Methods

  attr_reader :app

  def setup
    Travis::Config.config = { 'name' => 'i18n', 'url' => 'http://github.com/svenfuchs/i18n', 'command' => 'rake' }
    @app = Travis::Server.new
    super
  end

  test 'can render' do
    Travis::Build.create(
      :runner     => 'ci-i18n-client-191',
      :commit     => '25456ac13e5995b4a4f68dcf13d5ce95b1a687a7',
      :status     => true,
      :output     => 'build output',
      :created_at => Time.now
    )
    get '/'
    assert last_response.ok?
  end

  test 'can build' do
    Travis::Build.expects(:`).times(3).returns(RUNNER_RESULT.to_json)

    post '/', :payload => GITHUB_PAYLOAD
    assert last_response.ok?

    assert_equal %w(output output output), Travis::Build.all.map { |build| build.output }

    build = Travis::Build.first
    assert_equal '25456ac13e5995b4a4f68dcf13d5ce95b1a687a7', build.commit
    assert_equal 'http://github.com/svenfuchs/i18n', build.url
  end
end