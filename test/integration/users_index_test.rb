require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin_user)
    @non_admin = users(:non_admin_user)
    @user = users(:one)
    User.all.each { |user| user.image.attach(io: File.open('test/fixtures/kitten.jpg'), filename: 'kitten.jpg', content_type: 'image/jpeg') }
  end

  # ユーザー一覧表示とページネーション機能
  test "index including pagination" do
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      assert_select 'img'
    end
  end

  # deleteリンクとdelete機能
  test "index as admin including delete links" do
    log_in(@admin)
    get users_path
    User.paginate(page: 1).each do |user|
      if user != @admin
        assert_select "a[href=?]", user_path(user), text: "削除"
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  # 管理者以外にdeleteリンクを表示させない
  test "index as non_admin" do
    log_in(@non_admin)
    get users_path
    assert_select "a", text: "削除", count: 0
  end

end
