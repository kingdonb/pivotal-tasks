class MyDashboardController < ApplicationController
  attr_accessor :api
  attr_accessor :project
  attr_accessor :stories
  before_action :connect_pivotal_api

  def index
    #binding.pry
  end

  private
  def connect_pivotal_api
    self.api = TrackerApi::Client.new(token: ENV.fetch('PIVOTAL_API_KEY'))
    project_id = ENV.fetch('PIVOTAL_PROJECT')
    self.project = api.project(project_id)
    self.stories = project.stories(fields: ':default,tasks')
    #self.open_tasks = stories.
  end
end
