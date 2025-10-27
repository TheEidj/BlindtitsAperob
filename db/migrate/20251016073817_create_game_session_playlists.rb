class CreateGameSessionPlaylists < ActiveRecord::Migration[8.0]
  def change
    create_table :game_session_playlists do |t|
      t.references :game_session, null: false, foreign_key: true
      t.references :playlist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
