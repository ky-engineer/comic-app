require 'test_helper'

class LikesTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @post = posts(:three)
    log_in(@user)
  end

  # いいね＆いいね解除機能のテスト
  test "like und like_cancel a post" do
    assert_difference '@user.like_posts.count', 1 do
      post likes_path, params: { post_id: @post.id }
    end
    assert_difference '@user.like_posts.count', -1 do
      delete like_path(@user.likes.find_by(post_id: @post.id))
    end
  end

  # 投稿をいいねしたユーザー一覧ページのテスト
  test "like_posts page" do
    get like_posts_post_path(@user)
    @user.like_posts.each do |post|
      assert_match post.title, response.body
    end
  end

  # ユーザーがいいねした投稿一覧ページのテスト
  test "liked_by page" do
    get liked_by_user_path(@post.id)
    @post.liked_by.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end
end
