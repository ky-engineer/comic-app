require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @relationship = Relationship.new(follower_id: users(:one).id, followed_id: users(:two).id)
  end

  # 有効なrelationshipオブジェクトに対するバリデーション通過のテスト
  test "should be valid" do
    assert @relationship.valid?
  end


  # ↓バリデーションに対するテスト


  # follower_id属性の存在性
  test "follower_id should be present" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  # followed_id属性の存在性
  test "followed_id shuold be valid" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end


  # ↑バリデーションに対するテスト

  
end
