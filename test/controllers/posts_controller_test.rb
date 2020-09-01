require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @post = posts(:one)
    @wrong_user = users(:two)
  end


  #before_action :login_userに対するテスト

  test "should redirect new when not login" do
    get new_post_path
    assert_not flash.empty?
    assert_redirected_to new_session_path
  end


  test "should redirect create when not login" do
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { title: "test", content: "test", picture_url: "test" } }
    end
    assert_not flash.empty?
    assert_redirected_to new_session_path
  end

  test "should redirect destroy when not login" do
    assert_no_difference 'Post.count' do
      delete post_path(@post)
    end
    assert_not flash.empty?
    assert_redirected_to new_session_path
  end


  # before_action :correct_userに対するテスト
  test "should redirect destroy when login as wrong user" do
    log_in(@wrong_user)
    assert_no_difference 'Post.count' do
      delete post_path(@post)
    end
    assert_not flash.empty?
    assert_redirected_to root_path
  end

end
