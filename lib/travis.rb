module Travis
  autoload :Bob,    'travis/bob'
  autoload :Build,  'travis/build'
  autoload :Config, 'travis/config'
  autoload :Tasks,  'travis/tasks'
  autoload :Git,    'travis/git'
  autoload :Github, 'travis/github'
  autoload :Setup,  'travis/setup'
  autoload :Runner, 'travis/runner'
  autoload :Server, 'travis/server'

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