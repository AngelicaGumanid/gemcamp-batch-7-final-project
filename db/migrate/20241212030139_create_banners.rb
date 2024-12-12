class CreateBanners < ActiveRecord::Migration[7.0]
  def change
    create_table :banners do |t|
      t.string :preview
      t.datetime :online_at
      t.datetime :offline_at
      t.integer :status

      t.timestamps
    end
  end
end
