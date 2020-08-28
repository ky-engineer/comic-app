require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:one)
    remember(@user)
  end

  #有効な永続ログインに対し、current_userメソッドの機能を確認する
  test "current_user returns right user when right cookie exists" do
    assert_equal @user, current_user
    assert session[:user_id]
  end

  # 無効な永続ログインに対し、current_userメソッドがnilを返す事を確認する
  test "current_user returns nil when remember_token is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert current_user.nil?
  end
end
