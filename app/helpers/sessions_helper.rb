module SessionsHelper

  #フレンドリーフォワーディングのためのメソッド
  def friendly_forwarding
    if session[:forwarding_url]
      redirect_to session[:forwarding_url]
      session.delete(:forwarding_url)
    else
      redirect_to user_path(@user)
    end
  end

  # ログインしているユーザーを返す
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        session[:user_id] = user_id
        @current_user ||= user
      end
    end
  end

  # 永続的にログインする
  def remember(user)
    user.remember
    cookies.permanent[:remember_token] = user.remember_token
    cookies.permanent.signed[:user_id] = user.id
  end

  # 永続ログインを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

end
