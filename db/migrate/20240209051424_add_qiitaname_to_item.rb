class AddQiitanameToItem < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :qiitaname, :string
  end
end
