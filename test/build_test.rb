require File.expand_path('../test_helper', __FILE__)

class BuildTest < Test::Unit::TestCase
  include Travis::Github

  test 'build_from_remote' do
    Travis::Build.expects(:`).returns(RUNNER_RESULT.to_json)
    Travis::Build.create_from_remote('http://ci-i18n-runner-187.heroku.com', GITHUB_PAYLOAD.dup)

    assert_equal %w(output), Travis::Build.all.map { |build| build.output }

    build = Travis::Build.first
    assert_equal '25456ac13e5995b4a4f68dcf13d5ce95b1a687a7', build.commit
    assert_equal 'http://github.com/svenfuchs/i18n', build.url
  end
end