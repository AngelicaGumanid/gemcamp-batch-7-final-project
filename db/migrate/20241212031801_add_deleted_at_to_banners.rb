class AddDeletedAtToBanners < ActiveRecord::Migration[7.0]
  def change
    add_column :banners, :deleted_at, :datetime, default: nil
  end
end
