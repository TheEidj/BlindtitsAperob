class Team < ApplicationRecord
  has_many :game_session_teams
  has_many :game_sessions, through: :game_session_teams
  has_many :scores
end
