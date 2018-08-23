require 'net/http'

class UsersController < ApplicationController

  def index
    user = User.new
    response = user.getToken
    @api_token = response["access_token"]
  end

end
