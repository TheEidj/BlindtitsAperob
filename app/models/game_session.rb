class GameSession < ApplicationRecord
  has_many :game_session_playlists, -> { order(position: :asc) }, dependent: :destroy
  has_many :playlists, through: :game_session_playlists

  has_many :game_session_interludes, -> { order(position: :asc) }, dependent: :destroy
  has_many :interludes, through: :game_session_interludes

  has_many :game_session_teams, dependent: :destroy
  has_many :teams, through: :game_session_teams

  has_many :scores, dependent: :destroy

  enum :status, {
    upcoming: "upcoming",
    ongoing: "ongoing",
    archived: "archived",
    cancelled: "cancelled"
  }, validate: true
end
