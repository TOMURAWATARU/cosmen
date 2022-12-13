class Log < ApplicationRecord
  belongs_to :cosme
  default_scope -> { order(created_at: :desc) }
  validates :cosme_id, presence: true
end
