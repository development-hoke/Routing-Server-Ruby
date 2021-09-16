class AddStatusToPlan < ActiveRecord::Migration[5.2]
  def change
    add_column :plans, :status, :string, null: false, :after => :need_time
    change_column :users, :status, :string, null: false, :after => :user_attr
  end
end
