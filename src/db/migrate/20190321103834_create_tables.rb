class CreateTables < ActiveRecord::Migration[5.2]
  def change
    create_table :users, id: false do |t|
      t.string :id, limit: 36, primary_key: true, null: false
      t.string :name, null: false
      t.string :sex, null: false
      t.integer :age, null: false
      t.string :area, null: false
      t.string :mail_address, null: false
      t.timestamps
    end

    create_table :plans, id: false do |t|
      t.string :id, limit: 32, primary_key: true, null: false
      t.string :title, null: false
      t.text :descrption
      t.string :date
      t.string :transportation
      t.integer :need_time
      t.timestamps
      t.references :user, foreign_key: true, type: :string, limit: 36, null: false
    end

    create_table :spots, id: false do |t|
      t.string :id, limit: 32, primary_key: true, null: false
      t.integer :order, limit: 1, null: false
      t.integer :need_time
      t.string :google_maps_key, null: false
      t.timestamps
      t.references :plan, foreign_key: true, type: :string, limit: 32, null: false
    end

    create_table :likes do |t|
      t.references :user, foreign_key: true, type: :string, limit: 36, null: false
      t.references :plan, foreign_key: true, type: :string, limit: 32, null: false
      t.datetime :created_at, null: false
    end
  end
end
