require 'travis/bob'
require 'json'

module Travis
  class Runner
    attr_reader :env

    def call(env)
      @env = env
      status, output = Bob::Builder.new(payload).build
      body = { :status => status, :output => output, :commit => payload['commit'] }.to_json
      # what's an appropriate http status to signal a test failure?
      Rack::Response.new(body, status ? 200 : 400).finish
    rescue JSON::JSONError
      Rack::Response.new("Unparsable payload", 400).finish
    end

    protected

      def payload
        payload = JSON.parse(Rack::Request.new(env).POST["payload"] || '')
        payload.merge('command' => Config.command)
      end
  end
end