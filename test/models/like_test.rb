require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  def setup
    @like = Like.new(user_id: users(:one).id, post_id: posts(:one).id)
  end

  # 有効なlikeオブジェクトに対するバリデーション通過のテスト
  test "should be valid" do
    assert @like.valid?
  end


  # ↓バリデーションに対するテスト


  # user_id属性の存在性
  test "user_id should be present" do
    @like.user_id = nil
    assert_not @like.valid?
  end

  # post_id属性の存在性
  test "post_id should be present" do
    @like.user_id = nil
    assert_not @like.valid?
  end


  # ↑バリデーションに対するテスト

  
end
