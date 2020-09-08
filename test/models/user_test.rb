require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "example@example.com", password: "foobar", password_confirmation: "foobar")
    @user.image.attach(io: File.open('test/fixtures/kitten.jpg'), filename: 'kitten.jpg', content_type: 'image/jpeg' )
  end

  #有効なuserオブジェクトに対するバリデーション通過のテスト
  test "should be valid" do
    assert @user.valid?
  end


  # ↓バリデーションに対するテスト


  #name属性の存在性
  test "name should be present" do
    @user.name = " "
    assert_not @user.valid?
  end

  #name属性の長さ
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  #email属性の存在性
  test "email should be present" do
    @user.email = " "
    assert_not @user.valid?
  end

  #email属性の長さ
  test "email should not be too long" do
    @user.email = "a" * 51
    assert_not @user.valid?
  end

  #email属性の大文字・小文字を区別しない一意性
  test "email should be unique" do
    user2 = @user.dup
    user2.email = user2.email.upcase
    @user.save
    assert_not user2.valid?
  end

  #email属性のフォーマット
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[@example.com example@example,com example.at.example.com example@.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  #password属性の存在性
  test "password should be present" do
    @user.password = @user.password_confirmation = " "
    assert_not @user.valid?
  end

  #password属性の最小文字数
  test "password should not be short" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  # image属性の最小サイズ
  test "image should be less than 5MB" do
    @user.image.attach(io: File.open('test/fixtures/invalid_image_size.png'), filename: 'invalid_image_size.png', content_type: 'image/png')
    assert_not @user.valid?
  end

  # image属性のフォーマット
  test "image validation should reject invalid format" do
    @user.image.attach(io: File.open('test/fixtures/invalid_image_format.pdf'), filename: 'invalid_image_format.pdf', content_type: 'image/pdf')
    assert_not @user.valid?
  end

  # ↑バリデーションに対するテスト


  #email属性の小文字化に対するテスト
  test "email should be saved as lowercase" do
    mixed_address = "ExaMplE@ExaMple.Com"
    @user.email = mixed_address
    @user.save
    assert_equal @user.reload.email, mixed_address.downcase
  end

  # 紐づけられた投稿の削除に対するテスト
  test "associated posts should be destroyed when user is destroyed" do
    @user.save
    @user.posts.create!(title: "test_title", content: "test_content", picture_url: "test_picture_url")
    assert_difference 'Post.count', -1 do
      @user.destroy
    end
  end

  # feedメソッドに対するテスト
  test "feed should have the right posts" do
    one = users(:one)
    two = users(:two)
    four = users(:four)
    # フォローしているユーザーの投稿
    two.posts.each do |post_following|
      assert one.feed.include?(post_following)
    end
    # 自分自身の投稿
    one.posts.each do |post_self|
      assert one.feed.include?(post_self)
    end
    # フォローしていないユーザーの投稿
    four.posts.each do |post_unfollowed|
      assert_not one.feed.include?(post_unfollowed)
    end

  end

end
