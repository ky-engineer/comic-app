require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @other_user = users(:four)
    log_in(@user)
  end

  # フォロー＆フォロー解除機能のテスト
  test "follow and unfollow a user" do
    assert_difference '@user.following.count', 1 do
      post relationships_path, params: { followed_id: @other_user.id }
    end
    assert_difference '@user.following.count', -1 do
      delete relationship_path(@user.active_relationships.find_by(followed_id: @other_user.id))
    end
  end

  # フォロー一覧ページのテスト
  test "following page" do
    get following_user_path(@user)
    @user.following.each do |user|
      assert_select "a[href=?]", user_path(@user)
    end
  end

  # フォロワー一覧ページのテスト
  test "followers page" do
    get followers_user_path(@user)
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

end
