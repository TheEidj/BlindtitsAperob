class RemoveUserIdFromPlaylist < ActiveRecord::Migration[8.0]
  def change
    remove_reference :playlists, :user, foreign_key: true
  end
end
