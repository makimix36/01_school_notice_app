class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_to notifications_path, success: "ログインしました"
    else
     flash.now[:danger] = "メールアドレスまたはパスワードが間違っています"
     render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    flash[:success] = "ログアウトしました"
    redirect_to root_path
  end
end
