class AddStatusToGameSession < ActiveRecord::Migration[8.0]
  def change
    add_column :game_sessions, :status, :string, null: false, default: "upcoming"
  end
end
