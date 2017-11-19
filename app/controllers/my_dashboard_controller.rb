class MyDashboardController < ApplicationController
  attr_accessor :api
  attr_accessor :project
  attr_accessor :stories
  attr_accessor :delivered_stories
  attr_accessor :finished_stories
  attr_accessor :planned_stories
  attr_accessor :started_stories
  attr_accessor :open_stories
  attr_accessor :open_story_tasks
  attr_accessor :incomplete_current_tasks
  attr_accessor :completed_current_tasks
  before_action :connect_pivotal_api

  def index
    #binding.pry
  end

  private
  def connect_pivotal_api
    self.api               = TrackerApi::Client.new(token: ENV.fetch('PIVOTAL_API_KEY'))
    project_id             = ENV.fetch('PIVOTAL_PROJECT')
    self.project           = api.project(project_id)
    self.delivered_stories = project.stories(fields: ':default,tasks', with_state: 'delivered')
    self.finished_stories  = project.stories(fields: ':default,tasks', with_state: 'finished')
    self.planned_stories   = project.stories(fields: ':default,tasks', with_state: 'planned')
    self.started_stories   = project.stories(fields: ':default,tasks', with_state: 'started')
    self.open_stories      = [delivered_stories, finished_stories, planned_stories, started_stories].flatten
    #self.open_stories      = [delivered_stories, planned_stories, started_stories].flatten
    self.open_story_tasks  = open_stories.map(&:tasks).flatten.partition{|t| t.complete}
    self.completed_current_tasks = open_story_tasks[0]
    self.incomplete_current_tasks = open_story_tasks[1]
  end
end
