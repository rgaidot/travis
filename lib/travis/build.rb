require 'dm-core'
require 'cgi'

module Travis
  class Build
    include DataMapper::Resource

    property :id,         Serial
    property :runner,     String
    property :url,        String
    property :commit,     String
    property :command,    String
    property :status,     Boolean
    property :output,     Text
    property :created_at, DateTime

    class << self
      def create_from_remote(url, payload)
        result = `curl -sd payload=#{CGI.escape(payload.to_json)} #{url} 2>&1`
        attributes = JSON.parse(result)
        attributes = attributes.merge(:runner => url, :created_at => Time.now, :url => payload['repository']['url'])
        attributes.reject! { |key, value| !property_names.include?(key.to_sym) }
        Build.create(attributes)
      end

      def property_names
        @property_names ||= properties.map { |property| property.name }
      end
    end
    
    def commit_url
      "#{url}/commits/#{commit}"
    end
  
    def short_hash
      commit[0..6]
    end
    
    def stack
      @stack ||= begin
        stack = Setup::STACKS[runner =~ /runner-(\d*)\./ && $1] || ''
        stack.gsub(/bamboo-|aspen-/, '')
      end
    end
  end
end