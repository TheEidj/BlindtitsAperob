class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  has_many :user_playlists
  has_many :followed_playlists, through: :user_playlists, source: :playlist
end
