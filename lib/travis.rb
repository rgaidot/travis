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
      options.each { |option| send(:"#{option}_do", :install) }
    end

    def destroy(options)
      options.each { |option| send(:"#{option}_do", :destroy) }
    end
    
    protected

      def server_do(action)
        Setup.create('server').send(action)
      end

      def runners_do(action)
        Config.stacks.each { |stack| Setup.create('runner', stack).send(action) }
      end
  end
end