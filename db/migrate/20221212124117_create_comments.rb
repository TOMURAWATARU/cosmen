class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.integer :cosme_id
      t.integer :user_id
      t.text :content
      t.timestamps
    end
    add_index :comments, :user_id
    add_index :comments, :cosme_id 
  end
end
