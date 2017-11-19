class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # before_filter :authenticate, except: :ping

  def ping
    show_response("result", "success", :ok)
  end

  private
  def show_response( type, message, status )
    status ||= 200
    msg = {"errors" => { type => {"base" => message } }}
    respond_to do |format|
      format.xml  { render xml:  msg, status: status }
      format.json  { render json: msg, status: status }
      format.html  { render json: msg, status: status }
    end
  end
end
