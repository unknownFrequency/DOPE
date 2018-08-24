require 'net/http'

class UsersController < ApplicationController
  # before_action :authenticate

  def login
    @user = User.new
    # @oauth = Data.new
  end

  def create
    @user = User.new user_params
    base64_encoded_client_id_and_secret = Base64.encode64("#{params[:client_id]}:#{params[:client_secret]}")
    DataController.create_session(params[:api_key], base64_encoded_client_id_and_secret)

    respond_to do |format|
      if @user.save && session[:current_access_token]
        format.html { redirect_to user_path(@user), notice: 'Brugeren er nu oprettet.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def index

  end

  def show
    
  end

  protected
  def authenticate
  end

  private
    def user_params
      params.require(:user).permit(:email, :client_id, :client_secret, :api_key)
    end

end
