require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest

  # before_action :login_userに対するテスト

  test "should redirect create whern not logged in" do
    assert_no_difference 'Like.count' do
      post likes_path, params: { post_id: posts(:one).id }
    end
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Like.count' do
      delete like_path(likes(:one_two))
    end
  end
end
