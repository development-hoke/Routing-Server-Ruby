class AddColumnToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :profile, :string, :after => :onedate_id
    add_column :users, :address, :string, :after => :area
  end
end
