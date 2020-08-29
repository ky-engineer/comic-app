require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin_user)
    @non_admin = users(:non_admin_user)
    @user = users(:one)
  end

  # ユーザー一覧表示とページネーション機能
  test "index including pagination" do
    post sessions_path, params: { session: { email: @user.email, password: "password" } }
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end

  # deleteリンクとdelete機能
  test "index as admin including delete links" do
    post sessions_path, params: { session: { email: @admin.email, password: "password" } }
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
    post sessions_path, params: { session: { email: @non_admin.email, password: "password" } }
    get users_path
    assert_select "a", text: "削除", count: 0
  end

end
