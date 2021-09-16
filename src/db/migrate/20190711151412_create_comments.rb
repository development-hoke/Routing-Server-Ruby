class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments, id: false do |t|
      t.string :id, limit: 32, primary_key: true, null: false
      t.text :comment
      t.timestamps
      t.references :user, foreign_key: true, type: :string, limit: 36, null: false
      t.references :plan, foreign_key: true, type: :string, limit: 32, null: false
    end
  end
end
