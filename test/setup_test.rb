require File.expand_path('../test_helper', __FILE__)
require 'fileutils'

class SetupTest < Test::Unit::TestCase
  attr_reader :server

  def setup
    @current_dir = Dir.pwd
    @server = Travis::Setup.create('server', 'i18n')
    @server.stubs(:create_app)
    setup_test_repository
  end

  def teardown
    FileUtils.cd(@current_dir)
    `rm -rf tmp`
    server.stubs(:push_app)
  end

  test 'prepare_branch' do
    capture_stdout { server.prepare_branch }

    log = `git log --pretty=format:%s`.split("\n").compact
    files = `git ls-files`.split("\n").compact

    assert_equal ['update travis on ci-i18n'], log
    assert_equal %w(Gemfile config.ru config.yml), files
  end

  def setup_test_repository
    FileUtils.mkdir_p('tmp/ci')
    FileUtils.cd('tmp')
    `git init -q`
    system <<-sh
      echo 'gemfile' > ci/Gemfile
      echo 'config'  > ci/config.yml
      echo 'server'  > ci/server.ru
      echo 'runner'  > ci/runner.ru
      git add ci/Gemfile ci/config.yml ci/runner.ru ci/server.ru
      git commit -qm 'scaffolded app files'
    sh
  end
end