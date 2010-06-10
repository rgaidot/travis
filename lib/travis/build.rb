require 'dm-core'

module Travis
  class Build
    include DataMapper::Resource

    property :id,         Serial
    property :runner,     String
    property :commit,     String
    property :status,     Boolean
    property :output,     Text
    property :created_at, DateTime

    class << self
      def create_from_remote(url, payload)
        result = `curl -sd payload=#{CGI.escape(payload.to_json)} #{runner} 2>&1`
        attributes = JSON.parse(result)
        attributes.merge!(:runner => url, :created_at => Time.now)
        Build.create(attributes)
      end
    end
  end
end