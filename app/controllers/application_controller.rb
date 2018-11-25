class ApplicationController < ActionController::Base
  OAUTH_PROVIDER_URL = "https://authz.dinero.dk/dineroapi"

  before_action :refresh_token_if_expired, unless: -> { @user.nil? }

  def base64_encode(client_id, client_secret)
    Base64.strict_encode64 "#{client_id}:#{client_secret}" 
  end

  def create_session(base64_encoded_client_id_and_secret, api_key)
    url = "#{OAUTH_PROVIDER_URL}/oauth/token"

    response = HTTParty.post url, 
      headers: { 
        "Content-Type" => "application/x-www-form-urlencoded",
        Authorization: "Basic #{base64_encoded_client_id_and_secret}"
      },
      body: {
        grant_type: "password",
        scope: "read write",
        username: api_key,
        password: api_key,
      } 
      
      if status_code_200? response
        parsed_reponse = JSON.parse response.body
        set_access_token parsed_reponse
      end
  end

  def status_code_200?(response)
    parsed_reponse = JSON.parse response.body
    case response.code
      when 200
        logger.debug parsed_reponse
        true
      # when Net::HTTPUnauthorized
      #   logger.debug "#{parsed_reponse} HTTPUnauthorized"
      #   {'error' => "#{response.message}: Er de indtastede oplysninger korrekte?"}
      # when Net::HTTPServerError
      #   logger.debug "#{parsed_reponse} HTTPServerError"
      #   {'error' => "#{response.message}: Prøv igen senere?"}
      else
        logger.debug "#{parsed_reponse} Fejl"
        {'error' => response.message}
        false
      end
  end

  private

  def set_access_token(parsed_reponse)
    OAuth.create! token: parsed_reponse["access_token"], user_id: @user.id
    # logger.debug "session token -------------> #{session[:current_access_token]}"
    session[:current_access_token] = parsed_reponse["access_token"]
    session[:token_expires_at] = Time.now + parsed_reponse["expires_in"].to_i.seconds #3600
    # logger.debug "session token -------------> #{session[:token_expires_at]}"
  end

  def refresh_token_if_expired
    if !@user
      redirect_to login_path
    else
      base64_encoded_client_id_and_secret = base64_encode @user.client_id, @user.client_secret
      create_session(base64_encoded_client_id_and_secret, @user.api_key) if token_expired?
    end
  end

  def token_expired?
    expiry = Time.at session[:token_expires_at].to_i #.seconds
    return true if expiry < Time.now 
    false # token not expired. :D
  end
end
