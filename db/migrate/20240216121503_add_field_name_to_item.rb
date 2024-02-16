class AddFieldNameToItem < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :field_name, :string
  end
end
