class AddPositionToGameSessionPlaylists < ActiveRecord::Migration[8.0]
  def change
    add_column :game_session_playlists, :position, :integer, default: 0
  end
end
