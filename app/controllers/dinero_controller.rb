class DineroController < ApplicationController
  before_action :refresh_token_if_expired, unless: -> { @user.nil? }
  # before_action :set_access_token, unless: -> { !session[:current_access_token].nil? }

  def trade_offers(access_token)
    parsed_reponse = make_api_request access_token, "tradeoffers"
  end

  def post_trade_offer()
    #todo 
    # try catch.
    # add repetive headers as consts
    # contactname convert to guid
    response = HTTParty.post "#{ENV['DINERO_API_URL']}/#{ENV['ORGANIZATION_ID']}/tradeoffers", 
      headers: { 
        "Authorization" => "Bearer #{session[:current_access_token]}",
        "Host" => "api.dinero.dk",
        "Content-Type" => "application/json",
      },
      body: {
        ProductLines: [
          "BaseAmountValue" => "0",
          "Description" => "TEST MAND!",
          "LineType" => "Text",
        ],
        "ContactGuid" => "a8a8c94c-cdfc-46c7-a371-83bf8409e220",
        "contactName" => params["contact_name"],
        "description" => params["description"],
      }.to_json

      logger.debug JSON.parse response.body
  end

  def delete_trade_offer(guid)
    response = HTTParty.delete "#{ENV['DINERO_API_URL']}/#{ENV['ORGANIZATION_ID']}/tradeoffers/#{guid}", 
      headers: { 
        "Authorization" => "Bearer #{session[:current_access_token]}",
        "Host" => "api.dinero.dk",
        "Content-Type" => "application/json",
      }

  end

  def check_reponse_code(code)

  end

  def contacts(access_token)
    parsed_reponse = make_api_request access_token, "contacts"
  end

  def products(access_token)
    parsed_reponse = make_api_request access_token, "products"
  end

  def make_api_request(access_token, path, param=nil)
    # TODO: token_expired? && @user ? create_session()
    if param 
      url = "#{ENV['DINERO_API_URL']}/#{ENV['ORGANIZATION_ID']}/#{path}/#{param}"
    else
      url = "#{ENV['DINERO_API_URL']}/#{ENV['ORGANIZATION_ID']}/#{path}"
    end

    response = HTTParty.get url, 
      headers: { 
      "Authorization" => "Bearer #{access_token}",
      "Accept" => "application/json",
      "Content-Type" => "application/json",
      "Host" => "api.dinero.dk",
    }

    puts "x------------------------------------------------> #{logger.debug response}"
    puts "x------------------------------------------------> #{access_token}"
      # parsed_reponse = JSON.parse response.body
      # parsed_reponse["Collection"]
  end
end
