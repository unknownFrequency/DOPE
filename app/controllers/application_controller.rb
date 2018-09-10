class ApplicationController < ActionController::Base
  before_action :set_session, unless: -> { session[:access_token] }

  def set_session
    session[:init] ||= "true"
  end
end
