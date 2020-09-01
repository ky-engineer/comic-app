class Post < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :title, presence: true
  validates :content, presence: true, length: { maximum: 400 }
  default_scope -> { order(created_at: :desc) }

end
