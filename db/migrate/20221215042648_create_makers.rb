class CreateMakers < ActiveRecord::Migration[5.2]
  def change
    create_table :makers do |t|
      t.string :name
      t.integer :cosme_id
      t.string :genre
      t.timestamps
    end
    add_index :makers, :cosme_id 
  end
end
