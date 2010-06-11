$: << File.expand_path('../../lib', __FILE__)

require 'rubygems'
require 'test/unit'
require 'rack/test'
require 'test_declarative'
require 'mocha'

require 'pp'
require 'cgi'
require 'json'

require 'bob'
require 'travis'
require 'travis/build'
require 'mocha'
require 'capture_stdout'

require 'data_mapper'
require 'dm-migrations'
require 'dm-transactions'

DataMapper.setup(:default, "sqlite3:///tmp/travis-test.db")
DataMapper.auto_upgrade!

class Test::Unit::TestCase

  GITHUB_PAYLOAD = {
    'before'     => '533373f50625df607c9fed0092581b75abffb183',
    'repository' => { 'url' => 'http://github.com/svenfuchs/i18n', 'name' => 'i18n' },
    'commits'    => [{ 'id' => '25456ac13e5995b4a4f68dcf13d5ce95b1a687a7' }],
    'after'      => '25456ac13e5995b4a4f68dcf13d5ce95b1a687a7',
    'ref'        => 'refs/heads/master'
  }

  RUNNER_RESULT = {
    'scm'    => 'git',
    'uri'    => 'git://github.com/svenfuchs/i18n',
    'branch' => 'master',
    'commit' => '25456ac13e5995b4a4f68dcf13d5ce95b1a687a7',
    'status' => true,
    'output' => 'output',
    'command' => 'rake'
  }

  def teardown
    Travis::Build.destroy
  end
end
