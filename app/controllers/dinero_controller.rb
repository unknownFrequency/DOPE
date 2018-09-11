class DineroController < ApplicationController
  before_action :refresh_token_if_expired, unless: -> { @user.nil? }

  def check_reponse_code(code)

  end

  def contacts(access_token)
    parsed_reponse = make_api_request access_token, "contacts"
    parsed_reponse["Collection"]
  end

  def make_api_request(access_token, path)
      url = "#{ENV['DINERO_API_URL']}/#{ENV['ORGANIZATION_ID']}/#{path}"

      response = HTTParty.get url, 
          headers: { 
            "Authorization" => "Bearer #{access_token}",
            "Accept" => "application/json",
            "Content-Type" => "application/json",
            "Host" => "api.dinero.dk",
          }

      JSON.parse response.body
  end
end
