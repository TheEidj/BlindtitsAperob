class AddNumberToGameSession < ActiveRecord::Migration[8.0]
  def change
    add_column :game_sessions, :number, :integer
  end
end
