class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :cosme
  validates :user_id, presence: true
  validates :cosme_id, presence: true 
end
