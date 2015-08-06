class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    if current_user
      @users = User.order(:email)
    else
      redirect_to login_path
    end
  end

  def login
  end

  def authenticate
    user = User.authenticate(user_params[:email], user_params[:password])
    if user && user.failed_attempts == 0
      session[:user_id] = user.id
      flash[:notice] = "Bem vindo #{user.email}!"
    else
      message_to_user = "Usuário ou senha inválida."
      if user
        if user.failed_attempts >= 5
          attempts_info = "Usuário #{user.email} bloqueado!"
        else
          attempts_info = "Restam #{user.failed_attempts}/#{user.attempts} tentativas"
        end
        flash[:error] = message_to_user + " " + attempts_info
      else
        flash[:user] = message_to_user
      end
    end
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