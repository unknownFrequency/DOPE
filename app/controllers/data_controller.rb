require 'net/http' 
require 'uri'

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

    uri = URI.parse("https://authz.dinero.dk/dineroapi/oauth/token")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/x-www-form-urlencoded"
    request["Authorization"] = "Basic #{base64_encoded_client_id_and_secret}"
    request.set_form_data(
      "grant_type" => "password",
      "password" => api_key,
      "username" => api_key,
    )

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    logger.debug "------------------------------------------------- #{response.body.inspect} -------------------------------------------------------___-----"
    # response.code
    # response.body

    # url = "#{OAUTH_PROVIDER_URL}/oauth/token"

    # response = HTTParty.post url, 
    #   headers: { 
    #     "Content-Type" => "application/x-www-form-urlencoded",
    #     Authorization: "Basic #{base64_encoded_client_id_and_secret}"
    #   },
    #   body: {
    #     grant_type: "password",
    #     scope: "read write",
    #     username: api_key,
    #     password: api_key,
    #     # redirect_uri: "/contact"
    #   } 

  end

  private

  def self.status_code(response)
    case response
      when Net::HTTPSuccess
        set_access_token
      when Net::HTTPUnauthorized
        {'error' => "#{response.message}: Er de indtastede oplysninger korrekte?"}
      when Net::HTTPServerError
        {'error' => "#{response.message}: Prøv igen senere?"}
      else
        {'error' => response.message}
      end
  end

  def set_access_token
    session[:current_access_token] = response["access_token"] if response["access_token"]
  end



end
