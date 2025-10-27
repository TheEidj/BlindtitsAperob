class Score < ApplicationRecord
  belongs_to :game_session
  belongs_to :team
  belongs_to :track
end
