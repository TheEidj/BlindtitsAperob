class AddPlayerCountToTeams < ActiveRecord::Migration[8.0]
  def change
    add_column :teams, :player_count, :integer, default: 0
  end
end
