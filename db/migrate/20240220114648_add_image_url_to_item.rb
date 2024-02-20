class AddImageUrlToItem < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :imageurl, :string
  end
end
