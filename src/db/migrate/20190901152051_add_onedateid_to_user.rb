class AddOnedateidToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :onedate_id, :string, :after => :name
  end
end
