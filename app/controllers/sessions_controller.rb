class SessionsController < ApplicationController
  def new

  end

  def create
    @user = User.find_by(email: params[:session][:email])
    if @user && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      flash[:success] = "ログインしました。"
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      friendly_forwarding
    else
      flash.now[:danger] = "Eメールまたはパスワードが間違っています。"
      render "new"
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_url
  end


end
