class MyDashboardController < ApplicationController
  attr_accessor :api
  attr_accessor :project
  before_action :connect_pivotal_api

  def index
    #binding.pry
  end

  private
  def connect_pivotal_api
    self.api = TrackerApi::Client.new(token: ENV.fetch('PIVOTAL_API_KEY'))
    project_id = ENV.fetch('PIVOTAL_PROJECT')
    self.project = api.project(project_id).stories(fields: ':default,tasks')  
  end
end
