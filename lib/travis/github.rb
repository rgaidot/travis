require 'uri'

module Travis
  module Github
    # thanks, Bobette
    def map_from_github(payload)
      payload.delete('before')
      payload.delete('commits')
      payload['scm']    = 'git'
      payload['uri']    = git_uri(payload.delete('repository'))
      payload['branch'] = payload.delete('ref').split('/').last
      payload['commit'] = payload.delete('after')
      payload
    end

    def git_uri(repository)
      uri = URI.parse(repository['url'])
      uri.scheme = 'git'
      uri.to_s
    end
  end
end