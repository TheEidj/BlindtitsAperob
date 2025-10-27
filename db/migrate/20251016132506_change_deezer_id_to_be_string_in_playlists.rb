class ChangeDeezerIdToBeStringInPlaylists < ActiveRecord::Migration[8.0]
  def change
    change_column :playlists, :deezer_id, :string
  end
end
