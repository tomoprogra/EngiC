class AddUniqueIndexToIdentities < ActiveRecord::Migration[7.1]
  def change
    add_index :identities, [:uid, :provider], unique: true
  end
end
