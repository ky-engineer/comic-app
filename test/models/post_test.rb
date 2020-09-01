require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @post = @user.posts.build(title: "Example Comic", content: "Example review.", picture_url: "Example_URL" )
  end

  # 有効なpostオブジェクトに対するバリデーション通過のテスト
  test "should be valid" do
    assert @post.valid?
  end


  # ↓バリデーションに対するテスト


  # user_id属性のの存在性
  test "user_id should be present" do
    @post.user_id = nil
    assert_not @post.valid?
  end

  # title属性の存在性
  test "title should be present" do
    @post.title = " "
    assert_not @post.valid?
  end

  # content属性の存在性
  test "content id should be present" do
    @post.content = " "
    assert_not @post.valid?
  end

  # content属性の長さ
  test "content should be at most 400 characters" do
    @post.content = "a" * 401
    assert_not @post.valid?
  end


  # ↑バリデーションに対するテスト


  # 作成時間について降順で取得する
  test "order should be most recent first" do
    assert_equal posts(:most_recent), Post.first
  end


end
