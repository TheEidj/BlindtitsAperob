class CreateGameSessionTeams < ActiveRecord::Migration[8.0]
  def change
    create_table :game_session_teams do |t|
      t.references :game_session, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true

      t.timestamps
    end
  end
end
