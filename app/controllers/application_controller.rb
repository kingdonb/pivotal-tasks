class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # before_filter :authenticate, except: :ping

  def ping
    show_response("result", "success", :ok)
  end
end
