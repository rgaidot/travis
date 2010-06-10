require 'bob'

# monkey patch galore

Bob::Builder.class_eval do
  # let's return the actual result, eh?
  def completed(status, output)
    [status, output]
  end
end

Bob::SCM::Abstract.class_eval do
  # don't use separate directories per commit?
  def dir_for(commit)
    Bob.directory.join(path)
  end
end