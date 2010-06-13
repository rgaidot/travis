require File.expand_path('../test_helper', __FILE__)
require 'travis/helpers'

OUTPUT = <<-output
  skipping loading the i18n gem ...
  can't use KeyValue backend because: no such file to load -- rufus/tokyo
  can't use KeyValue backend because: no such file to load -- rufus/tokyo
  Skipping tests for I18n::Backend::Cldr because the ruby-cldr gem is not installed.
  can't use KeyValue backend because: no such file to load -- rufus/tokyo
  Loaded suite test/all
  Started
  ...........................................................................................................................................................................................................................................................................................................................F......................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................
  Finished in 11.871623 seconds.
 
    1) Failure:
  test_adds_locale_and_hash_of_key_and_hash_of_options(I18nBackendCacheTest)
      [/disk1/tmp/git-github-com-svenfuchs-i18n-master/test/backend/cache_test.rb:63:in `test_adds_locale_and_hash_of_key_and_hash_of_options'
       /home/slugs/209688_ba02c2e_f532/mnt/.bundle/gems/gems/mocha-0.9.8/lib/mocha/integration/test_unit/ruby_version_186_and_above.rb:19:in `__send__'
       /home/slugs/209688_ba02c2e_f532/mnt/.bundle/gems/gems/mocha-0.9.8/lib/mocha/integration/test_unit/ruby_version_186_and_above.rb:19:in `run']:
  <"i18n//en/1190108/23982594624700"> expected but was
  <"i18n//en/1190108/946957375">.
 
  1090 tests, 1527 assertions, 1 failures, 0 errors
output

class HelpersTest < Test::Unit::TestCase
  include Travis::Helpers
  
  # test 'build_output' do
  #   build = Travis::Build.new(:output => OUTPUT, :command => 'rake')
  #   puts OUTPUT
  #   puts '-' * 49
  #   puts build_output(build)
  # end
end