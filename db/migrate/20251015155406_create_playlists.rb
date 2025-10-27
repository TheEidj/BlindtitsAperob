class CreatePlaylists < ActiveRecord::Migration[8.0]
  def change
    create_table :playlists do |t|
      t.string :name
      t.integer :nbTrack
      t.boolean :played
      t.text :url

      t.timestamps
    end
  end
end
