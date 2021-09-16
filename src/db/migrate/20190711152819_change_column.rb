class ChangeColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :attribute, :string, null: false, :after => :mail_address
    remove_column :spots, :google_maps_key
    add_column :spots, :name, :string, null: false, :after => :id
    add_column :spots, :description, :text, :after => :name
    add_column :spots, :latitude, :float, limit: 53, null: false, :after => :need_time
    add_column :spots, :longitude, :float, limit: 53, null: false, :after => :latitude
    change_column :comments, :comment, :text, null: false
  end
end
