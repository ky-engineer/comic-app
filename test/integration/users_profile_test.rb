require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @user.image.attach(io: File.open('test/fixtures/kitten.jpg'), filename: 'kitten.jpg', content_type: 'image/jpeg')
    @wrong_user = users(:two)
    @posts = @user.posts
  end

  # ユーザー詳細ページの表示内容
  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_match @user.name, response.body
    assert_select 'img'
    @posts.each do |post|
      assert_match post.title, response.body
      assert_match post.content, response.body
      assert_match post.picture_url, response.body
    end
  end

  # 投稿のdeleteリンク＆delete機能
  test "profile as correct user including delete links" do
    log_in(@user)
    get user_path(@user)
    @user.posts.paginate(page: 1).each do |post|
      assert_select "a[href=?]", post_path(post), text: "削除"
    end
    assert_difference 'Post.count', -1 do
      delete post_path(@user.posts.first)
    end
    assert_not flash.empty?
    assert_redirected_to root_path
  end

  # 今ログインしているユーザー以外のユーザーの投稿について、deleteリンクを表示しない
  test "profile as wrong user" do
    log_in(@wrong_user)
    get user_path(@user)
    assert_select "a", text: "削除", count: 0
  end
end
