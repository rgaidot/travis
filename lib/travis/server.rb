require 'sinatra'
require 'cgi'
require 'json'

module Travis
  class Server < Sinatra::Application
    include Helpers
    
    attr_reader :name, :url

    def initialize # (name, url)
      @name = Config.name
      @url  = Config.url
      super()
    end

    set :views, File.expand_path('../views', __FILE__)

    get '/' do
      @builds = Build.all(:order => [:created_at.desc], :limit => 50)
      erb :builds
    end

    post '/' do
      build_all
      Rack::Response.new('ok', 200).finish
    end

    protected

      def build_all
        Setup.runners.each do |runner|
          # should probably spawn some process per runner here
          Build.create_from_remote(runner.url, params[:payload])
        end
      end
  end
end