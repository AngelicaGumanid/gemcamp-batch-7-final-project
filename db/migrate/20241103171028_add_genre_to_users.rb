class AddGenreToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :genre, :integer, default: 0
  end
end
