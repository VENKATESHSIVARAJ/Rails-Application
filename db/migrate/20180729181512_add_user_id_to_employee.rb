class AddUserIdToEmployee < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :user_id, :bigint
    add_foreign_key :employees, :users
  end
end
