class AddPictureToCosmes < ActiveRecord::Migration[5.2]
  def change
    add_column :cosmes, :picture, :string
  end
end
