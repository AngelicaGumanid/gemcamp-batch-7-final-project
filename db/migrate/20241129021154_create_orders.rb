class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :offer, foreign_key: true
      t.string :serial_number, null: false, unique: true
      t.integer :state, default: 0, null: false
      t.decimal :amount, precision: 10, scale: 2
      t.integer :coin
      t.text :remarks
      t.integer :genre, default: 0, null: false

      t.timestamps
    end

    add_index :orders, :serial_number, unique: true
  end
end
