class UsersController < ApplicationController

  def login
    @user = User.new
  end

  def create
    base64_encoded_client_id_and_secret = base64_encode params[:user][:client_id], params[:user][:client_secret]

    respond_to do |format|
      email = params[:user][:email]
      @user = User.new user_params unless User.exists? email: email 

      if @user && @user.save 
	create_session( base64_encoded_client_id_and_secret, @user.api_key)
	flash[:notice] = "Du er nu oprettet i databasen med email: #{email}"
	format.html { redirect_to user_path @user }
	format.json { render :show }
      elsif User.exists? email: params[:user][:email]
	@user = User.where(email: email).take
	create_session(base64_encoded_client_id_and_secret, @user.api_key) 
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
    dinero = DineroController.new
    access_token = session[:current_access_token]
    # @contacts = dinero.contacts access_token
    # @products = dinero.products access_token
    # @trade_offers = dinero.trade_offers access_token
  end

  protected

  private
    def user_params
      params.require(:user).permit(:email, :client_id, :client_secret, :api_key, :encrypted_dinero_token)
    end

end
