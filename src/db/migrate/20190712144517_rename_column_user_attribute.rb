class RenameColumnUserAttribute < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :attribute, :user_attr
  end
end
