class CreateUserPlaylists < ActiveRecord::Migration[8.0]
  def change
    create_table :user_playlists do |t|
      t.references :user, null: false, foreign_key: true
      t.references :playlist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
