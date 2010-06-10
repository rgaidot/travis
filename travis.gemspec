# encoding: utf-8

$: << File.expand_path('../lib', __FILE__)
require 'travis/version'

Gem::Specification.new do |s|
  s.name         = "travis"
  s.version      = Travis::VERSION
  s.authors      = ["Sven Fuchs"]
  s.email        = "svenfuchs@artweb-design.de"
  s.homepage     = "http://github.com/svenfuchs/travis"
  s.summary      = "[summary]"
  s.description  = "[description]"

  s.add_dependency  'sinatra'
  s.add_dependency  'bob'
  s.add_dependency  'data_mapper' # no idea what we actually need here. dm is confusing
  s.add_dependency  'dm-core'
  s.add_dependency  'dm-migrations'
  s.add_dependency  'dm-postgres-adapter'
  s.add_dependency  'data_objects'
  s.add_dependency  'do_postgres'
  s.add_dependency  'pg'

  s.files        = Dir['{lib/**/*,[A-Z]*}']
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'
end
