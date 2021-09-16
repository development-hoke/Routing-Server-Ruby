class RemoveColumnFromSpots < ActiveRecord::Migration[5.2]
  def change
    remove_column :spots, :order, :integer
    remove_column :spots, :need_time, :integer
  end
end
