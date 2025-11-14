class CreateGameSessionInterludes < ActiveRecord::Migration[8.0]
  def change
    create_table :game_session_interludes do |t|
      t.references :game_session, null: false, foreign_key: true
      t.references :interlude, null: false, foreign_key: true

      t.timestamps
    end

    add_index :game_session_interludes, [ :game_session_id, :interlude_id ], unique: true, name: 'index_game_session_interludes_unique'
  end
end
