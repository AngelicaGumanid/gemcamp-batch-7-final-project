class CreateTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :tickets do |t|
      t.references :item, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :serial_number
      t.string :state, null: false, default: 'pending'
      t.integer :coins, null: false, default: 1

      t.timestamps
    end
  end
end
