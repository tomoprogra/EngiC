class AddXNameGithubNameToItem < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :xname, :string
    add_column :items, :githubname, :string
    add_index :items, :xname, unique: true
    add_index :items, :githubname, unique: true
  end
end
