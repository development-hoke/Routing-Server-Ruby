class CreateHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :histories do |t|
      t.string :word, null: false
      t.datetime :created_at, null: false
      t.references :user, foreign_key: true, type: :string, limit: 36, null: false
    end
  end
end
