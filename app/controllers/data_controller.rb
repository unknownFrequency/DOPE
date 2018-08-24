class DataController < ApplicationController

  OAUTH_PROVIDER_URL = "https://authz.dinero.dk/dineroapi"

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
      redirect_to "/session"
    end
  end

  def contact(id)

  end

  def self.create_session(base64_encoded_client_id_and_secret, api_key)
    url = "#{OAUTH_PROVIDER_URL}/oauth/token"

    response = HTTParty.post url, 
      headers: { 
        Authorization: "Basic #{base64_encoded_client_id_and_secret}",
        Accept: "application/x-www-form-urlencoded"
      },
      body: {
        grant_type: "password",
        scope: "read write",
        username: api_key,
        password: api_key,
        # redirect_uri: "/contact"
      } 

      session[:current_access_token] = response["access_token"] if response["access_token"]
  end
end
