class CreateWinners < ActiveRecord::Migration[7.0]
  def change
    create_table :winners do |t|
      t.references :item, null: false, foreign_key: true
      t.references :ticket, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true
      t.integer :item_batch_count
      t.string :state
      t.decimal :price, precision: 10, scale: 2
      t.datetime :paid_at
      t.references :admin, null: false, foreign_key: { to_table: :users }
      t.string :picture
      t.text :comment

      t.timestamps
    end
  end
end
