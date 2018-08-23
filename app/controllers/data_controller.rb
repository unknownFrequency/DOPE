class DataController < ApplicationController
  def index
    if session[:current_access_token]
      @session = session[:current_access_token]
      # @user = HTTParty.get "#{ENV['OAUTH_PROVIDER_URL']}/api/v1/users/me.json", { query: { access_token: session[:current_access_token]} }
    else
      # "grant_type=password&scope=read write&username=#{ENV["ENCODED_CLIENT_ID_AND_SECRET"]}&password=#{ENV["ENCODED_CLIENT_ID_AND_SECRET"]}&redirect_uri=#{ENV['OAUTH_REDIRECT_URI']}"
      # redirect_to "#{ENV['OAUTH_PROVIDER_URL']}/oauth/token?client_id=#{ENV['OAUTH_TOKEN']}&redirect_uri=#{ENV['OAUTH_REDIRECT_URI']}&response_type=code"
    end
  end

  def create_session
    # require_params = "client_id=#{ENV['OAUTH_TOKEN']}&client_secret=#{ENV['OAUTH_SECRET']}&code=#{params[:code]}&grant_type=authorization_code&redirect_uri=#{ENV['OAUTH_REDIRECT_URI']}"
    # request_params = "grant_type=password
    #   &scope=read write
    #   &username=#{ENV["BASE64_ENCODED_CLIENT_ID_AND_SECRET"]}
    #   &password=#{ENV["BASE64_ENCODED_CLIENT_ID_AND_SECRET"]}
    #   &redirect_uri=#{ENV['OAUTH_REDIRECT_URI']}"


    @response = HTTParty.post("#{ENV['OAUTH_PROVIDER_URL']}/oauth/token", 
      headers: { 
        Authorization: "Basic #{ENV['BASE64_ENCODED_CLIENT_ID_AND_SECRET']}",
        Accept: "application/x-www-form-urlencoded"
      },
      body: {
        grant_type: "password",
        scope: "read write",
        username: ENV["API_KEY"],
        password: ENV["API_KEY"],
        redirect_uri: ENV['OAUTH_REDIRECT_URI']
        # client_id: ENV["CLIENT_ID"],
        # client_secret: ENV["CLIENT_SECRET"],
      })

    logger.debug "--------> RESPONSE: #{JSON.parse @response.body} <-----------"
    @token = session[:current_access_token] = @response["access_token"]
    render json: @response
    # redirect_to ENV["OAUTH_REDIRECT_URI"]
  end
end
