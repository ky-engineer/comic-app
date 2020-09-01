require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @wrong_user = users(:two)
    @non_admin = users(:non_admin_user)
  end

  #Strong Parametersに対するテスト
  test "admin should not be edited via the web" do
    post users_path, params: { user: { name: "test", email: "test@test.com", password: "foobar", password_confirmation: "foobar", admin: true } }
    assert_not assigns[:user].admin?

    patch user_path(@user), params: { user: { name: @user.name, email: @user.email, password: "", password_confirmation: "", admin: true } }
    @user.reload
    assert_not @user.admin?
  end


  #before_action :login_userに対するテスト


  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to new_session_path
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: "not_logged_in", email: "not_logged_in@test.com", password: "", password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to new_session_path
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_not flash.empty?
    assert_redirected_to new_session_path
  end


  # before_action :correct_userに対するテスト


  test "should redirect edit when logged in as wrond user" do
    log_in(@wrong_user)
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to root_path
  end

  test "should redirect update when logged in as wrond user" do
    log_in(@wrong_user)
    patch user_path(@user), params: { user: { name: "not_logged_in", email: "not_logged_in@test.com", password: "", password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to root_path
  end

  # before_action :admin_userに対するテスト
  test "should redirect destroy when logged in as non_admin user" do
    log_in(@non_admin)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_not flash.empty?
    assert_redirected_to root_path
  end

end
