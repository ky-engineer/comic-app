require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  # 無効なユーザー情報の更新
  test "unsuccessful edit" do
    log_in(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: {
      name: "name",
      email: "email",
      password: "foo",
      password_confirmation: "bar" } }
    assert_template 'users/edit'
  end

  # 有効なユーザー情報の更新とフレンドリーフォワーディング
  test "successfui edit with friendly forwarding" do
    # フレンドリーフォワーディング
    get edit_user_path(@user)
    assert_redirected_to new_session_path
    log_in(@user)
    assert_redirected_to edit_user_path(@user)

    # 有効なユーザー情報の更新
    new_name = "new_name"
    new_email = "new_email@new_email.com"
    patch user_path(@user), params: { user: {
      name: new_name ,
      email: new_email,
      password: "",
      password_confirmation: "",
      image: fixture_file_upload('test/fixtures/kitten.jpg', 'image/jpg') } }
    assert @user.image.attached?
    assert_redirected_to user_path(@user)
    assert_not flash.empty?
    @user.reload
    assert_equal new_name, @user.name
    assert_equal new_email, @user.email
  end


end
