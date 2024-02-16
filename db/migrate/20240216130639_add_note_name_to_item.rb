class AddNoteNameToItem < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :note_name, :string
  end
end
