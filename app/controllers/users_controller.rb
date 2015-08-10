class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    if @current_user = current_user
      @users = User.order(:email)
    else
      redirect_to login_path
    end
  end

  def login
  end

  def logout
    session[:user_id] = nil
    redirect_to root_url, alert: "Logout realizado com sucesso!"
  end

  def show
    @current_user = current_user
  end

  def authenticate
    flash_key, message = User.authenticate(params[:user][:email], params[:user][:password])
    flash[flash_key] = message
    session[:user_id] = User.find_by_email(params[:user][:email]).id if flash_key == :notice
    redirect_to root_url
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :attempts, :failed_attempts)
  end

end
