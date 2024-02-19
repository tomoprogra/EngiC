class AddLocationToItem < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :location, :string
  end
end
