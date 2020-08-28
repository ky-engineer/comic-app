require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    # @user = users(:one)
  end

  #ユーザー作成時のStrong Parametersに対するテスト
  test "admin should not be edited via the web when user is created" do
    post users_path, params: { user: { name: "test", email: "test@test.com", password: "foobar", password_confirmation: "foobar", admin: true } }
    assert_not assigns[:user].admin?
  end

end
