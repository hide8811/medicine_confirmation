class AddColumnsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :last_name, :string,       null: false
    add_column :users, :first_name, :string,      null: false
    add_column :users, :last_name_kana, :string,  null: false
    add_column :users, :first_name_kana, :string, null: false
    add_column :users, :status, :string
  end
end
