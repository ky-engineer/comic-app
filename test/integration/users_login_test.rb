require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  # 無効なログイン
  test "login with invalid information" do
    get new_session_path
    assert_template "sessions/new"
    post sessions_path, params: { session: { email: "", password: "" } }
    assert_template "sessions/new"
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  # 有効なログインとログアウト
  test "login with valid information followed by logout" do
    get new_session_path
    assert_template "sessions/new"
    post sessions_path, params: { session: { email: @user.email, password: "password" } }
    assert_redirected_to @user
    follow_redirect!
    assert_template "users/show"
    delete session_path(current_user)
    assert session[:user_id].nil?
    assert_redirected_to root_url
  end

  # 永続ログイン
  test "login with remembering" do
    post sessions_path, params: { session: { email: @user.email, password: "password", remember_me: '1' } }
    assert cookies['user_id']
    assert assigns(:user).authenticated?(cookies['remember_token'])
  end

  # 永続ログインの破棄
  test "login without remembering" do
    post sessions_path, params: { session: { email: @user.email, password: "password", remember_me: '1' } }
    delete logout_path
    post sessions_path, params: { session: { email: @user.email, password: "password", remember_me: '0' } }
    assert_empty cookies['user_id']
    assert_empty cookies['remember_token']
    assert_nil assigns(:user).remember_digest
  end

end
