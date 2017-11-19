class MyDashboardController < ApplicationController
  attr_accessor :api
  attr_accessor :project
  attr_accessor :stories
  attr_accessor :current_page_desc

  attr_accessor :accepted_stories
  attr_accessor :unscheduled_stories
  attr_accessor :planned_stories
  attr_accessor :unstarted_stories
  attr_accessor :started_stories
  attr_accessor :finished_stories
  attr_accessor :delivered_stories

  before_action :connect_pivotal_api

  attr_accessor :open_stories
  attr_accessor :open_story_tasks
  attr_accessor :incomplete_current_tasks
  attr_accessor :completed_current_tasks
  def index
    prepare_current
    self.current_page_desc = 'current iteration'

    self.open_story_tasks  = open_stories.map(&:tasks).
      flatten.partition{|t| t.complete}
    self.completed_current_tasks = open_story_tasks[0]
    self.incomplete_current_tasks = open_story_tasks[1]
  end

  attr_accessor :closed_stories
  attr_accessor :closed_story_tasks
  attr_accessor :completed_orphaned_tasks
  attr_accessor :incomplete_orphaned_tasks
  def orphaned
    prepare_orphans
    self.current_page_desc = 'orphaned tasks list'

    self.closed_story_tasks = closed_stories.map(&:tasks).
      flatten.partition{|t| t.complete}
    self.completed_orphaned_tasks = closed_story_tasks[0]
    self.incomplete_orphaned_tasks = closed_story_tasks[1]
  end

  private

  def prepare_current
    setup_current_story_states
  end
  def prepare_orphans
    setup_orphaned_story_states
  end

  def connect_pivotal_api
    self.api               = TrackerApi::Client.new(token: ENV.fetch('PIVOTAL_API_KEY'))
    setup_project
  end

  def setup_project
    project_id             = ENV.fetch('PIVOTAL_PROJECT')
    self.project           = api.project(project_id)
  end

  def setup_story_states
    #self.stories             = project.stories(fields: ':default,tasks')
  end

  def setup_orphaned_story_states
    self.accepted_stories    = project.stories(fields: ':default,tasks', with_state: 'accepted')
    self.unscheduled_stories = project.stories(fields: ':default,tasks', with_state: 'unscheduled')
    #self.unstarted_stories = project.stories(fields: ':default,tasks', with_state: 'unstarted')

    self.closed_stories    = [ accepted_stories,
                               unscheduled_stories ].flatten
    #                           unstarted_stories,
  end

  def setup_current_story_states
    self.planned_stories   = project.stories(fields: ':default,tasks', with_state: 'planned')
    self.started_stories   = project.stories(fields: ':default,tasks', with_state: 'started')
    self.finished_stories  = project.stories(fields: ':default,tasks', with_state: 'finished')
    self.delivered_stories = project.stories(fields: ':default,tasks', with_state: 'delivered')

    self.open_stories      = [ planned_stories,
                               started_stories,
                               finished_stories,
                               delivered_stories ].flatten
  end
end
