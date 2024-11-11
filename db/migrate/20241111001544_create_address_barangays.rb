class CreateAddressBarangays < ActiveRecord::Migration[7.0]
  def change
    create_table :address_barangays do |t|
      t.belongs_to :city
      t.string :code
      t.string :name
      t.timestamps
    end
  end
end
