class RemoveColorFromTeams < ActiveRecord::Migration[8.0]
  def change
    remove_column :teams, :color, :string
  end
end
