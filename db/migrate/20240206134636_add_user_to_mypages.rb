class AddUserToMypages < ActiveRecord::Migration[7.1]
  def change
    add_reference :mypages, :user, null: false, foreign_key: true
  end
end
