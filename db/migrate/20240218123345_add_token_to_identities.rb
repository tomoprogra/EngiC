class AddTokenToIdentities < ActiveRecord::Migration[7.1]
  def change
    add_column :identities, :token, :string
  end
  add_index :identities, [:provider, :uid], unique: true
end
