class GameSession < ApplicationRecord
  has_many :game_session_playlists
  has_many :playlists, through: :game_session_playlists

  has_many :game_session_teams
  has_many :teams, through: :game_session_teams

  has_many :scores
end
