class AddDeezerIdToPlaylist < ActiveRecord::Migration[8.0]
  def change
    add_column :playlists, :deezer_id, :integer
  end
end
