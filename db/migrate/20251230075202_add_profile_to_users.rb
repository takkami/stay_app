class AddProfileToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :name, :string, null: false, default: ""
    add_column :users, :introduction, :text
  end
end
