require 'yaml'

module Travis
  module Config
    class << self
      def name
        config['name']
      end

      def config
        @config ||= YAML.load_file(File.expand_path("#{Dir.pwd}/ci/config.yml"))
      end

      def method_missing(name, *args)
        config.key?(name.to_s) ? config[name.to_s] : super
      end
    end
  end
end