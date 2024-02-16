class AddZennnameToItems < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :zennname, :string
  end
end
