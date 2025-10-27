class AddDateToGameSession < ActiveRecord::Migration[8.0]
  def change
    add_column :game_sessions, :date, :datetime
  end
end
