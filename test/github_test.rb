require File.expand_path('../test_helper', __FILE__)

class GithubTest < Test::Unit::TestCase
  include Travis::Github

  test 'map_from_github' do
    payload = {
      'before'     => '533373f50625df607c9fed0092581b75abffb183',
      'repository' => { 'url' => 'http://github.com/svenfuchs/i18n', 'name' => 'i18n' },
      'commits'    => [{ 'id' => '25456ac13e5995b4a4f68dcf13d5ce95b1a687a7' }],
      'after'      => '25456ac13e5995b4a4f68dcf13d5ce95b1a687a7',
      'ref'        => 'refs/heads/master'
    }
    expected = {
      'scm'     => 'git',
      'uri'     => 'git://github.com/svenfuchs/i18n',
      'branch'  => 'master',
      'commit'  => '25456ac13e5995b4a4f68dcf13d5ce95b1a687a7'
    }
    assert_equal expected, map_from_github(payload)
  end
end