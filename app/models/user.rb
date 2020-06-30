class User < ApplicationRecord
  before_save :saved_as_lowercase
  validates :name, presence: true, length: { maximum: 50 }
  #有効なメールアドレスに対する正規表現
  VALID_EMAIL_REGEXP = /\A\w+[\w_\.-]*\w+@\w+(\.\w+)*\.[a-zA-Z]+\z/
  validates :email, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }, format: { with: VALID_EMAIL_REGEXP }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  private

  #email属性を小文字にする
  def saved_as_lowercase
    email.downcase!
  end

end
