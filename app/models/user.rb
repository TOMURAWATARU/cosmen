class User < ApplicationRecord
  has_many :cosmes, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :favorites, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :lists, dependent: :destroy
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Cosme.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

  def follow(other_user)
    following << other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  # 現在のユーザーがフォローされていたらtrueを返す
  def followed_by?(other_user)
    followers.include?(other_user)
  end

  # コスメをお気に入りに登録する
  def favorite(cosme)
    Favorite.create!(user_id: id, cosme_id: cosme.id)
  end

  # コスメをお気に入り解除する
  def unfavorite(cosme)
    Favorite.find_by(user_id: id, cosme_id: cosme.id).destroy
  end

  # 現在のユーザーがお気に入り登録してたらtrueを返す
  def favorite?(cosme)
    !Favorite.find_by(user_id: id, cosme_id: cosme.id).nil?
  end

  # コスメをリストに登録する
  def list(cosme)
    List.create!(user_id: cosme.user_id, cosme_id: cosme.id, from_user_id: id)
  end

  # コスメをリストから解除する
  def unlist(list)
    list.destroy
  end

  # 現在のユーザーがリスト登録してたらtrueを返す
  def list?(cosme)
    !List.find_by(cosme_id: cosme.id, from_user_id: id).nil?
  end
end
