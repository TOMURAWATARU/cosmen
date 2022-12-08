class CreateCosmes < ActiveRecord::Migration[5.2]
  def change
    create_table :cosmes do |t|
      t.string :name
      t.text :description
      t.text :tips
      t.text :reference
      t.integer :popularity
      t.text :cosme_memo
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :cosmes, [:user_id, :created_at]
  end
end
