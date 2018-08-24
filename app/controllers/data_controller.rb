class DataController < ApplicationController
  def index
    if session[:current_access_token]
      url = "#{ENV['DINERO_API_URL']}/#{ENV['ORGANIZATION_ID']}/contacts"

      response = HTTParty.get url, 
          headers: { 
            Authorization: "Bearer #{session[:current_access_token]}",
            Accept: "application/json",
            "Content-Type" => "application/json",
          }
      # render plain: response["connection"].inspect
      contacts = response["Collection"][4158303]
      render plain: contacts
    else
      redirect_to "/session"
    end
  end

  def contact(id)

  end

  def create_session
    url = "#{ENV['OAUTH_PROVIDER_URL']}/oauth/token"

    response = HTTParty.post url, 
      headers: { 
        Authorization: "Basic #{ENV['BASE64_ENCODED_CLIENT_ID_AND_SECRET']}",
        Accept: "application/x-www-form-urlencoded"
      },
      body: {
        grant_type: "password",
        scope: "read write",
        username: ENV["API_KEY"],
        password: ENV["API_KEY"]
        # redirect_uri: ENV['OAUTH_REDIRECT_URL']
      } 

    session[:current_access_token] = response["access_token"]
    redirect_to "/index"
  end
end
