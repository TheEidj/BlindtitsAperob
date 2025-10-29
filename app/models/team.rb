class Team < ApplicationRecord
  has_many :game_session_teams
  has_many :game_sessions, through: :game_session_teams
  has_many :scores

  validates :name, presence: true
  validates :color, presence: true
  validates :player_count, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
