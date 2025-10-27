class GameSessionTeam < ApplicationRecord
  belongs_to :game_session
  belongs_to :team
end
