class CreateScores < ActiveRecord::Migration[8.0]
  def change
    create_table :scores do |t|
      t.references :game_session, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.references :track, null: false, foreign_key: true
      t.integer :points

      t.timestamps
    end
  end
end
