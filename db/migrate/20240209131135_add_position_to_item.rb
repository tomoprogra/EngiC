class AddPositionToItem < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :position, :integer
  end
end
