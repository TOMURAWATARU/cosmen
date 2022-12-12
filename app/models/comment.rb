class Comment < ApplicationRecord
  belongs_to :cosme
  validates :user_id, presence: true
  validates :cosme_id, presence: true
  validates :content, presence: true, length: { maximum: 50 }
end
