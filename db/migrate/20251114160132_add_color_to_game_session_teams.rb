class AddColorToGameSessionTeams < ActiveRecord::Migration[8.0]
  def change
    add_column :game_session_teams, :color, :string
  end
end
