class RemoveContactInfoFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :address, :string
    remove_column :users, :phone_number, :string
  end
end
