module Travis
  module Github
    def parse_github_payload(payload)
      map_from_github(JSON.parse(payload))
    end

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
      URI(repository['url']).tap { |u| u.scheme = 'git' }.to_s
    end
  end
end