require 'erb'

module Travis
  class Setup
    STACKS = {
      '186' => 'aspen-mri-1.8.6',
      '187' => 'bamboo-ree-1.8.7',
      '191' => 'bamboo-mri-1.9.1'
    }

    class << self
      def name
        Config.name
      end
      
      def stacks
        STACKS.keys
      end

      def create(type, stack = nil)
        new(type, Config.name, stack)
      end

      def runners
        @runners ||= STACKS.keys.map { |stack| create('runner', stack) }
      end

      def app_names
        @app_names ||= begin
          puts "checking for existing apps ..."
          `heroku list`.split("\n").map { |name| name.split(/\s/).first }
        end
      end

      def remotes
        @remotes ||= `git remote`.split("\n")
      end

      def scaffold(name)
        source = File.expand_path('../templates', __FILE__)
        target = "#{Dir.pwd}/ci/"
        `mkdir -p #{target}`

        url = "http://github.com/[yourname]/#{name}" # TODO
        scaffold_template("#{source}/config.yml", "#{target}/config.yml", binding)

        %w(Gemfile runner.ru server.ru).each do |file|
          `cp #{source}/#{file} #{target}/#{file}`
        end
      end

      def scaffold_template(source, target, binding)
        content = File.read(source)
        content = ERB.new(content).result(binding)
        File.open(target, 'w+') { |f| f.write(content) }
      end
    end

    attr_reader :type, :name, :stack

    def initialize(type, name, stack)
      @type, @name, @stack = type, name, stack || '187'
    end

    def install
      preserve_branch do
        create_app unless app_exists?
        add_remote unless remote_exists?
        prepare_branch
        push_app
      end
      reset
    end

    def app
      "ci-#{name}" + (type == 'runner' ? "-#{type}-#{stack}" : '' )
    end

    def url
      "http://#{app}.heroku.com"
    end

    def app_exists?
      self.class.app_names.include?(app)
    end

    def create_app
      puts "creating #{app} ..."
      `heroku create #{app} --stack #{STACKS[stack.to_s]}`
    end

    def remote_exists?
      self.class.remotes.include?(app)
    end

    def add_remote
      puts "adding git remote #{app} ..."
      `git remote add #{app} git@heroku.com:#{app}.git`
    end

    def preserve_branch
      current_branch = `git symbolic-ref HEAD`.strip
      yield
      `git symbolic-ref HEAD #{current_branch}`  # switch back to original branch
    end

    def prepare_branch
      puts "preparing branch #{app} ..."
      `git symbolic-ref HEAD refs/heads/ci-tmp`  # switch to tmp branch
      `rm -f .git/index`                         # clear branch ancestry
      index_files                                # add files to the index
      `git commit -qm 'update travis on #{app}'` # commit files
    end

    def index_files
      files = {
        'ci/config.yml' => 'config.yml',
        "ci/#{type}.ru" => 'config.ru',
        'ci/Gemfile'    => 'Gemfile'
      }
      files.each do |source, target|
        hash = `git hash-object -w #{source}`.strip
        `git update-index --add --cacheinfo 100644 #{hash} #{target}`
      end
    end

    def push_app
      puts "pushing branch #{app} to heroku ..."
      `git push #{app} ci-tmp:master --force`    # push to heroku
    end

    def reset
      `git remote rm #{app}`                     # remove remote
      `git branch -D ci-tmp`                     # delete tmp branch
    end
  end
end