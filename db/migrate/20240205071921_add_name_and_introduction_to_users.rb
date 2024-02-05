class AddNameAndIntroductionToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :name, :string
    add_column :users, :introduction, :text
  end
end
