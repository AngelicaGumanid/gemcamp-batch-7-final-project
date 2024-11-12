class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
      t.integer :genre, null: false, default: 0
      t.string :name
      t.string :street_address
      t.string :phone_number
      t.text :remark
      t.boolean :is_default, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
