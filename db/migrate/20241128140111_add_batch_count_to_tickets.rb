class AddBatchCountToTickets < ActiveRecord::Migration[7.0]
  def change
    add_column :tickets, :batch_count, :integer
  end
end
