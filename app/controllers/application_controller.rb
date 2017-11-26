class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate, except: :ping
  before_action :user_login

  def authenticate
    #render status: 401, html: "<p>redirect to CAS</p>".html_safe unless request.session.key?("cas")
    render status: 401, plain: "" unless request.session.key?("cas")
  end

  def user_login
    if session['cas']['user'].nil?
      login_err("Your single sign on authentication could not be verified.")
      return false
    end
    session['user_id'] = session['cas']['user'].upcase
    #rval = check_access_and_setup_session(session['user_id']) if session['user_roles'].nil?
    #User.find_by_netid(session['user_id']).try(:activity!)
    #return rval

  #rescue => e
  #  login_err(<<-eos)
  #    An error has occurred in verifying your user access to this application.
  #    Verify that all appropriate web services are available.
  #    class: #{e.class.name} : #{e.message}
  #  eos
  #  return false
  end

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
