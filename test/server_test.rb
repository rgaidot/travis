require File.expand_path('../test_helper', __FILE__)

class ServerTest < Test::Unit::TestCase
  include Rack::Test::Methods

  GITHUB_PAYLOAD = {
    'before'     => '533373f50625df607c9fed0092581b75abffb183',
    'repository' => { 'url' => 'http://github.com/svenfuchs/i18n', 'name' => 'i18n' },
    'commits'    => [{ 'id' => '25456ac13e5995b4a4f68dcf13d5ce95b1a687a7' }],
    'after'      => '25456ac13e5995b4a4f68dcf13d5ce95b1a687a7',
    'ref'        => 'refs/heads/master'
  }

  attr_reader :app

  def setup
    Travis::Config.config = { 'name' => 'i18n', 'command' => 'rake' }
    @app = Travis::Server.new('i18n', 'http://github.com/svenfuchs/i18n')
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
    Travis::Build.expects(:create_from_remote).times(3).with do |url, payload|
      expected_url = %r(http://ci-i18n-runner-[\d]{3}.heroku.com)
      expected_payload = {
        "scm"    =>"git",
        "uri"    =>"git://github.com/svenfuchs/i18n",
        "branch" =>"master",
        "commit" =>"25456ac13e5995b4a4f68dcf13d5ce95b1a687a7"
      }
      expected_url =~ url && expected_payload == payload
    end
    post '/', :payload => GITHUB_PAYLOAD.to_json
    assert last_response.ok?
  end
end