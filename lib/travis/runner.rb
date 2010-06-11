require 'travis/bob'
require 'json'

module Travis
  class Runner
    include Github

    def call(env)
      response = build(env).to_json
      # what's an appropriate http status to signal a test failure?
      Rack::Response.new(response, response['status'] ? 200 : 400).finish
    rescue JSON::JSONError
      Rack::Response.new("Unparsable payload", 400).finish
    end

    def build(env)
      payload = JSON.parse(Rack::Request.new(env).POST["payload"] || '')
      payload = map_from_github(payload)
      payload.merge!('command' => Config.command)

      status, output = Bob::Builder.new(payload).build
      payload.merge('status' => status, 'output' => output)
    end
  end
end