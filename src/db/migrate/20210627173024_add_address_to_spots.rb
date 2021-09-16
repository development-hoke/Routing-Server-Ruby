class AddAddressToSpots < ActiveRecord::Migration[5.2]
  def change
    add_column :spots, :address, :string, comment: "住所"
  end
end
