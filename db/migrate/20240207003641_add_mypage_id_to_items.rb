class AddMypageIdToItems < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :mypage_id, :integer
    add_index :items, :mypage_id
  end
end
