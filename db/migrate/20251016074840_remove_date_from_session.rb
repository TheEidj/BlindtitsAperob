class RemoveDateFromSession < ActiveRecord::Migration[8.0]
  def change
    remove_column :sessions, :date, :datetime
  end
end
