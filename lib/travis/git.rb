module Travis
  module Git

    def branch_exists?(name)
      !!`git show-ref refs/heads/#{name}`
    end
  end
end