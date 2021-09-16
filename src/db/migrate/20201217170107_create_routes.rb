class CreateRoutes < ActiveRecord::Migration[5.2]
  def change
    create_table :routes do |t|
      t.references :plan, foreign_key: true, type: :string, limit: 32, null: false
      t.references :spot, foreign_key: true, type: :string, limit: 32, null: false
      t.integer :order, limit: 1, null: false, comment: "順番"
      t.integer :need_time, comment: "所要時間"
      t.timestamps
    end
  end
end
