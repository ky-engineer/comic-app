require 'test_helper'

class PostsCreateTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  # 無効な投稿
  test "create a invalid post" do
    log_in(@user)
    get new_post_path
    assert_template 'posts/new'
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { title: " " , content: " " , picture_url: " " } }
    end
    assert_template 'posts/new'
  end

  # 有効な投稿
  test "create a valid post" do
    log_in(@user)
    get new_user_path
    assert_difference 'Post.count', 1 do
      post posts_path, params: { post: { title: "test_title" , content: "test_content" , picture_url: "test_pictutre_url" } }
    end
    assert_not flash.empty?
    assert_redirected_to root_path
  end

end
