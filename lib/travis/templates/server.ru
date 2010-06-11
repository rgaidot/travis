# TODO remove this once this has been released as a gem
$: << ::File.expand_path('../lib', __FILE__)

require 'rubygems'
require 'travis'
require 'travis/build'
require 'data_mapper'
require 'dm-migrations'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3:///tmp/travis-development.db")
DataMapper.auto_upgrade!

# name = ENV['TRAVIS_NAME'] || raise('TRAVIS_NAME not set')
# url  = ENV['TRAVIS_URL']  || raise('TRAVIS_URL not set')

run Travis::Server.new # (name, url)