require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  #無効なサインアップ
  test "signup with invalid information" do
    get new_user_path
    assert_template 'users/new'
    assert_no_difference "User.count" do
      post users_path, params: { user: { name: " ", email: "invalid@invalid", password: "foo", passworn_confirmation: "bar" } }
    end
    assert_template 'users/new'
  end

  # 有効なサインアップ
  test "signup with valid information" do
    get new_user_path
    assert_template 'users/new'
    assert_difference "User.count", 1 do
      post users_path, params: { user: { name: "Example User", email: "example@example.com", password: "foobar", password_confirmation: "foobar" } }
    end
    assert_not flash.empty?
    assert_redirected_to user_path(assigns(:user))
  end
end
