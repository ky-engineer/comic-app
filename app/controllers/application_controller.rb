class ApplicationController < ActionController::Base
  include SessionsHelper

  # before_action用のメソッド
  # ログインしているかどうか
  def login_user
    if session[:user_id].nil?
      flash[:warning] = "ログインしてください"
      session[:forwarding_url] = request.original_url if request.get?
      redirect_to new_session_path
    end
  end
end
