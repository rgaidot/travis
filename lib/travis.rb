module Travis
  autoload :Bob,     'travis/bob'
  autoload :Build,   'travis/build'
  autoload :Config,  'travis/config'
  autoload :Git,     'travis/git'
  autoload :Github,  'travis/github'
  autoload :Helpers, 'travis/helpers'
  autoload :Runner,  'travis/runner'
  autoload :Server,  'travis/server'
  autoload :Setup,   'travis/setup'
  autoload :Tasks,   'travis/tasks'

  class << self
    def scaffold(name)
      Setup.scaffold(name)
    end

    def install(options)
      options.each { |option| send(:"install_#{option}") }
    end

    def install_server
      Setup.create('server').install
    end

    def install_runners
      Config.stacks.each { |stack| Setup.create('runner', stack).install }
    end
  end
end