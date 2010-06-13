require 'thor'

module Travis
  class Tasks < Thor
    namespace :travis

    desc "setup [name]", "Scaffold Travis setup."
    method_options :name => :optional # the library name

    def setup
      name = options['name'] || File.basename(Dir.pwd)
      Travis.scaffold(name)
    end

    desc "install", "Install/update your Travis setup to Heroku."
    method_options :all     => :boolean,
                   :server  => :boolean,
                   :runners => :boolean
    def install
      options = self.options.keys
      options = %w(server runners) if options.empty? || options.include?('all')
      Travis.install(options)
    end

    desc "destroy", "Destroy Travis setup on Heroku."
    method_options :all     => :boolean,
                   :server  => :boolean,
                   :runners => :boolean
    def destroy
      options = self.options.keys
      options = %w(server runners) if options.empty? || options.include?('all')
      Travis.destroy(options)
    end

    protected

      def options
        Hash[super.to_a] # i can haz hash
      end
  end
end