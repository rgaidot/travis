require File.expand_path('../test_helper', __FILE__)

class BuildTest < Test::Unit::TestCase
  GITHUB_PAYLOAD = {
    'before'     => '533373f50625df607c9fed0092581b75abffb183',
    'repository' => { 'url' => 'http://github.com/svenfuchs/i18n', 'name' => 'i18n' },
    'commits'    => [{ 'id' => '25456ac13e5995b4a4f68dcf13d5ce95b1a687a7' }],
    'after'      => '25456ac13e5995b4a4f68dcf13d5ce95b1a687a7',
    'ref'        => 'refs/heads/master'
  }

  test 'build_from_remote' do
    Travis::Build.expects(:`).returns({ :status => true, :output => 'output' }.to_json)
    Travis::Build.create_from_remote('http://ci-i18n-runner-187.heroku.com', 'payload')
    assert_equal %w(output), Travis::Build.all.map { |build| build.output }
  end
end