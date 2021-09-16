class CreateStaff < ActiveRecord::Migration[5.2]
  def change
    create_table :staff, id: false do |t|
      t.string :id, limit: 8, primary_key: true, null: false
      t.string :name, null: false
      t.string :password_digest, null: false
      t.string :session_key, limit: 32
      t.timestamps
    end
  end
end
