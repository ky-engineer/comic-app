class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :liked_by, through: :likes, source: :user
  validates :user_id, presence: true
  validates :title, presence: true
  validates :content, presence: true, length: { maximum: 400 }
  default_scope -> { order(created_at: :desc) }

end
