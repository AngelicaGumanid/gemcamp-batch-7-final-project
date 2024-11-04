class AddColumToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :username, :string
    add_column :users, :phone, :string
    add_column :users, :coins, :integer, default: 0
    add_column :users, :total_deposit, :decimal, precision: 15, scale: 2, default: 0.0
    add_column :users, :children_members, :integer, default: 0
  end
end
