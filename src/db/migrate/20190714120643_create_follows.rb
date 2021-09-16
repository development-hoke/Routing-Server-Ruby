class CreateFollows < ActiveRecord::Migration[5.2]
  def change
    create_table :follows do |t|
      t.references :user, foreign_key: true, type: :string, limit: 36, null: false
      t.references :follow_user, foreign_key: { to_table: :users }, type: :string, limit: 36, null: false
      t.datetime :created_at, null: false
    end
  end
end
