require 'uri'

class Repository < ActiveRecord::Base
  has_many :builds, :dependent => :delete_all
  has_one :last_build,   :class_name => 'Build', :order => 'started_at DESC'
  has_one :last_success, :class_name => 'Build', :order => 'started_at DESC', :conditions => { :status => 0 }
  has_one :last_failure, :class_name => 'Build', :order => 'started_at DESC', :conditions => { :status => 1 }

  class << self
    def timeline
      # should probably denormalize the last build attributes which are relevant to the timeline at some point
      includes(:last_build).where(Build.arel_table[:started_at].not_eq(nil)).order(Build.arel_table[:started_at].desc)
    end
  end

  before_create :init_names

  def as_json(options = {})
    repository_keys = [:id, :name, :url, :last_duration]
    last_build_options = { :only => [:id, :number, :commit, :message, :status, :log, :started_at, :finished_at, :author_name, :author_email, :committer_name, :committer_email] }
    super(:only => repository_keys, :include => { :last_build => last_build_options })
  end

  protected

    def init_names
      self.name ||= URI.parse(url).path.split('/')[-2, 2].join('/')
      self.username = name.split('/').first
    end
end
