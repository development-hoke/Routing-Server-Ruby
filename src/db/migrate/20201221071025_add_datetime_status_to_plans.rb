class AddDatetimeStatusToPlans < ActiveRecord::Migration[5.2]
  def change
    add_column :plans, :datetime_status, :string, null: false, :after => :status, comment: '投稿時日時表示ステータス'
  end
end
