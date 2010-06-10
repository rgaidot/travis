require 'yaml'

module Travis
  module Config
    class << self
      def config
        @config ||= begin
          file = File.exists?("#{Dir.pwd}/config.yml") ? 'config.yml' : 'ci/config.yml'
          YAML.load_file("#{Dir.pwd}/#{file}")
        end
      end

      def config=(config)
        @config = config
      end

      def name
        config['name']
      end

      def method_missing(name, *args)
        config.key?(name.to_s) ? config[name.to_s] : super
      end
    end
  end
end