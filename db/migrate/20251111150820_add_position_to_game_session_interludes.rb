class AddPositionToGameSessionInterludes < ActiveRecord::Migration[8.0]
  def change
    add_column :game_session_interludes, :position, :integer, default: 0
  end
end
