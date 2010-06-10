# TODO remove this once this has been released as a gem
$: << ::File.expand_path('../lib', __FILE__)

require 'rubygems'
require 'travis'

run Travis::Runner.new