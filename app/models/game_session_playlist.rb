class GameSessionPlaylist < ApplicationRecord
  belongs_to :game_session
  belongs_to :playlist
end
