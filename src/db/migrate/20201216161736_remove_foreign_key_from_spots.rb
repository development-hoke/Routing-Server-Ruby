class RemoveForeignKeyFromSpots < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :spots, :plans
    remove_index :spots, :plan_id
    change_column :spots, :plan_id, :string, limit: 32, null: true, comment: "デートプランID"
  end
end
