class Playlist < ApplicationRecord
  has_many :tracks, dependent: :destroy
  has_many :game_session_playlists
  has_many :game_sessions, through: :game_session_playlists
  has_many :user_playlists
  has_many :followers, through: :user_playlists, source: :user

  def created_by?(user)
    return false if user.nil? || user.deezer_id.nil?
    creator.to_s == user.deezer_id.to_s
  end

  def followed_by?(user)
    return false if user.nil?
    followers.exists?(user.id)
  end
end
