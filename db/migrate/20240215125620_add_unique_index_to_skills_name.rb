class AddUniqueIndexToSkillsName < ActiveRecord::Migration[7.1]
  def change
    add_index :skills, :name, unique: true
  end
end
