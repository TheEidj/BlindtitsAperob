class AddCreatorToPlaylist < ActiveRecord::Migration[8.0]
  def change
    add_column :playlists, :creator, :bigint
  end
end
