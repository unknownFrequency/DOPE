class ApplicationController < ActionController::Base
  OAUTH_PROVIDER_URL = "https://authz.dinero.dk/dineroapi"

  before_action :set_session, unless: -> { session.exists? }
  helper_method :set_session


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
      
      check_status_code response
  end

  private

  def check_status_code(response)
    parsed_reponse = JSON.parse response.body
    case response.code
      when 200
        logger.debug parsed_reponse
        set_access_token parsed_reponse
      when Net::HTTPUnauthorized
        logger.debug "#{parsed_reponse} HTTPUnauthorized"
        {'error' => "#{response.message}: Er de indtastede oplysninger korrekte?"}
      when Net::HTTPServerError
        logger.debug "#{parsed_reponse} HTTPServerError"
        {'error' => "#{response.message}: Prøv igen senere?"}
      else
        logger.debug "#{parsed_reponse} Other error"
        {'error' => response.message}
      end
  end

  def set_access_token(parsed_reponse)
    session[:current_access_token] = parsed_reponse["access_token"]
    session[:token_expires_at] = Time.now + parsed_reponse["expires_in"].to_i #3600
    logger.debug "session token -------------> #{session[:token_expires_at]}"
  end

  def refresh_token_if_expired
    if token_expired?
      response    = RestClient.post "#{ENV['DOMAIN']}oauth2/token", :grant_type => 'refresh_token', :refresh_token => self.refresh_token, :client_id => ENV['APP_ID'], :client_secret => ENV['APP_SECRET']
      refreshhash = JSON.parse(response.body)

      token_will_change!
      expiresat_will_change!

      self.token     = refreshhash['access_token']
      self.expiresat = DateTime.now + refreshhash["expires_in"].to_i.seconds

      self.save
      puts 'Saved'
    end
  end

  def token_expired?
    expiry = Time.at session[:token_expires_at]
    return true if expiry < Time.now # expired token, so we should quickly return
    # token_expires_at = expiry
    # save if changed?
    false # token not expired. :D
  end
end
