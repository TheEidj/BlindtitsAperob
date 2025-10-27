class CreateTracks < ActiveRecord::Migration[8.0]
  def change
    create_table :tracks do |t|
      t.references :playlist, foreign_key: :playlist_id
      t.text :name
      t.text :artist
      t.timestamps
    end
  end
end
