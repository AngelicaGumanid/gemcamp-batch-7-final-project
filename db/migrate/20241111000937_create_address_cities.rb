class CreateAddressCities < ActiveRecord::Migration[7.0]
  def change
    create_table :address_cities do |t|
      t.belongs_to :province
      t.string :code
      t.string :name
      t.timestamps
    end
  end
end
