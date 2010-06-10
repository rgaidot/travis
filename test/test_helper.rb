$: << File.expand_path('../../lib', __FILE__)

require 'rubygems'
require 'test/unit'
require 'rack/test'
require 'test_declarative'
require 'database_cleaner'
require 'mocha'

require 'pp'
require 'cgi'
require 'json'

require 'bob'
require 'travis'
require 'travis/build'
require 'mocha'
require 'capture_stdout'

DataMapper.setup(:default, "sqlite3:///tmp/travis-test.db")
DataMapper.auto_upgrade!

DatabaseCleaner.strategy = :truncation

class Test::Unit::TestCase
  def teardown
    DatabaseCleaner.clean
  end
end
