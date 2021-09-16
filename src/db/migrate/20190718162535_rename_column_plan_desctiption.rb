class RenameColumnPlanDesctiption < ActiveRecord::Migration[5.2]
  def change
    rename_column :plans, :descrption, :description
  end
end
