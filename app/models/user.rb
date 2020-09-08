class User < ApplicationRecord
  has_one_attached :image
  has_many :posts, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  attr_accessor :remember_token
  before_save :saved_as_lowercase
  validates :name, presence: true, length: { maximum: 50 }
  #有効なメールアドレスに対する正規表現
  VALID_EMAIL_REGEXP = /\A\w+[\w_\.-]*\w+@\w+(\.\w+)*\.[a-zA-Z]+\z/
  validates :email, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }, format: { with: VALID_EMAIL_REGEXP }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :image,
    content_type: { in: %w[image/jpeg image/gif image/png], message: "無効なファイル形式です" },
    size: { less_than: 5.megabytes, message: "5MB以下の画像を選んでください" }


  #email属性を小文字にする
  def saved_as_lowercase
    email.downcase!
  end

  # 引数のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # rememberトークンのハッシュ値をデータベースに保存する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # データベースに保存したrememberトークンのハッシュ値を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # 引数のハッシュ値が、データベースに保存しているrememberトークンのハッシュ値と一致するか確認する
  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # 自分とフォローしているユーザーの投稿を返す
  def feed
    following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    Post.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  end

end
