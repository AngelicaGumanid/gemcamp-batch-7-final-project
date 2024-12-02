class ChangeStateToStringInOrders < ActiveRecord::Migration[7.0]
  def change
    change_column :orders, :state, :string, default: "pending", null: false
  end
end
