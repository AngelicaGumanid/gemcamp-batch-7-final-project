class AddParentIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :parent_id, :integer
  end
end
