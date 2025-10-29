class GameSession < ApplicationRecord
  has_many :game_session_playlists, dependent: :destroy
  has_many :playlists, through: :game_session_playlists

  has_many :game_session_teams, dependent: :destroy
  has_many :teams, through: :game_session_teams

  has_many :scores, dependent: :destroy

  scope :upcoming, -> { where("date >= ?", Time.current).order(date: :asc) }
  scope :past, -> { where("date < ?", Time.current).order(date: :desc) }

  def upcoming?
    date && date >= Time.current
  end
end
