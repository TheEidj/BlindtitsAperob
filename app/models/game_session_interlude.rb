class GameSessionInterlude < ApplicationRecord
  belongs_to :game_session
  belongs_to :interlude

  validates :game_session_id, uniqueness: { scope: :interlude_id }
end
