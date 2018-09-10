require 'net/http'

class UsersController < ApplicationController

  def login
    @user = User.new
    # @oauth = Data.new
  end

  def create
    base64_encoded_client_id_and_secret = Base64.strict_encode64("#{params[:user][:client_id]}:#{params[:user][:client_secret]}")

    respond_to do |format|
      @user = User.new user_params unless User.exists? email: params[:user][:email] 

      if @user && @user.save 
	DataController.create_session( base64_encoded_client_id_and_secret, @user.api_key)
	flash[:notice] = "Du er nu oprettet i databasen med email: #{params[:user][:email]}"
	format.html { redirect_to user_path @user }
	format.json { render :show }
      elsif User.exists? email: params[:user][:email]
	@user = User.where(email: params[:user][:email]).take
	DataController.create_session(base64_encoded_client_id_and_secret, @user.api_key) 
	format.html { redirect_to user_path @user }
	format.json { render :show }
      else
	format.html { render :new }
	format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def index

  end

  def show
    @user = User.find params[:id]
    puts session.inspect
  end

  protected

  private
    def user_params
      params.require(:user).permit(:email, :client_id, :client_secret, :api_key)
    end

end
