class RemovePlaceidFromSpots < ActiveRecord::Migration[5.2]
  def change
    remove_column :spots, :placeid, :string
  end
end
