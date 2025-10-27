class ChangeDeezerITypedToStringInUsers < ActiveRecord::Migration[8.0]
  def change
    change_column :users, :deezer_id, :string
    change_column :playlists, :deezer_id, :string
  end
end
