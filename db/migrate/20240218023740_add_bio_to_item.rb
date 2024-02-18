class AddBioToItem < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :bio, :text
  end
end
