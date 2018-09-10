# require 'net/http' 
# require 'uri'

class DataController < ApplicationController
  # before_action :set_session, unless: -> { session.nil? }

  def index
    if session[:current_access_token]
      url = "#{ENV['DINERO_API_URL']}/#{ENV['ORGANIZATION_ID']}/contacts"

      response = HTTParty.get url, 
          headers: { 
            "Authorization" => "Bearer #{session[:current_access_token]}",
            "Accept" => "application/json",
            "Content-Type" => "application/json",
          }
      # render plain: response["connection"].inspect
      contacts = response["Collection"][4158303]
      render plain: contacts
    else
      render plain: @user.inspect
      # redirect_to "/session"
    end
  end

  def contact(id)

  end



  # def self.set_session
  #   session[:init] ||= "true"
  # end


end
