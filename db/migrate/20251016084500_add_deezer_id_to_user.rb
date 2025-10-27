class AddDeezerIdToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :deezer_id, :integer
  end
end
