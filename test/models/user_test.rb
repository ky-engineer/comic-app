require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "example@example.com", password: "foobar", password_confirmation: "foobar")
  end

  #有効なuserオブジェクトに対するバリデーション通過のテスト
  test "should be valid" do
    assert @user.valid?
  end

  #name属性の存在性に対するバリデーションのテスト
  test "name should be present" do
    @user.name = " "
    assert_not @user.valid?
  end

  #name属性の長さに対するバリデーションのテスト
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  #email属性の存在性に対するバリデーションのテスト
  test "email should be present" do
    @user.email = " "
    assert_not @user.valid?
  end

  #email属性の長さに対するバリデーションのテスト
  test "email should not be too long" do
    @user.email = "a" * 51
    assert_not @user.valid?
  end

  #email属性の大文字・小文字を区別しない一意性に対するバリデーションのテスト
  test "email should be unique" do
    user2 = @user.dup
    user2.email = user2.email.upcase
    @user.save
    assert_not user2.valid?
  end

  #email属性のフォーマットに対するバリデーションのテスト
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[@example.com example@example,com example.at.example.com example@.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  #email属性の小文字化に対するテスト
  test "email should be saved as lowercase" do
    mixed_address = "ExaMplE@ExaMple.Com"
    @user.email = mixed_address
    @user.save
    assert_equal @user.reload.email, mixed_address.downcase
  end


  #password属性の存在性に対するバリデーションのテスト
  test "password should be present" do
    @user.password = @user.password_confirmation = " "
    assert_not @user.valid?
  end

  #password属性の最小文字数に対するバリデーションのテスト
  test "password should not be short" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end
