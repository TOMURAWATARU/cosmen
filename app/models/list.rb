class List < ApplicationRecord
  belongs_to :user
  belongs_to :cosme
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :cosme_id, presence: true
  validates :from_user_id, presence: true
end
