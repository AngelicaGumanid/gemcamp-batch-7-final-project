class CreateOffers < ActiveRecord::Migration[7.0]
  def change
    create_table :offers do |t|
      t.string :image
      t.string :name
      t.integer :status
      t.decimal :amount
      t.decimal :coin

      t.timestamps
    end
  end
end
