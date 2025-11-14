class Interlude < ApplicationRecord
  has_many :game_session_interludes, dependent: :destroy
  has_many :game_sessions, through: :game_session_interludes

  validates :title, presence: true
end
