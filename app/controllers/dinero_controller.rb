class DineroController < ApplicationController
  before_action :refresh_token_if_expired, unless: -> { @user.nil? }

  def check_reponse_code(code)

  end

  def contacts(access_token)
    parsed_reponse = make_api_request access_token, "contacts"
  end

  def products(access_token)
    parsed_reponse = make_api_request access_token, "products"
  end

  def make_api_request(access_token, path)
    # TODO: token_expired? && @user ? create_session()
      url = "#{ENV['DINERO_API_URL']}/#{ENV['ORGANIZATION_ID']}/#{path}"

      response = HTTParty.get url, 
          headers: { 
            "Authorization" => "Bearer #{access_token}",
            "Accept" => "application/json",
            "Content-Type" => "application/json",
            "Host" => "api.dinero.dk",
          }

      parsed_reponse = JSON.parse response.body
      parsed_reponse["Collection"]
  end
end
