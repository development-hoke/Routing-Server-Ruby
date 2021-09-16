class AddStatusToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :status, :string, :after => :user_attr
  end
end
