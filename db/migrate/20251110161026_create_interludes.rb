class CreateInterludes < ActiveRecord::Migration[8.0]
  def change
    create_table :interludes do |t|
      t.string :title, null: false
      t.text :lyrics
      t.boolean :done, default: false

      t.timestamps
    end
  end
end
