# encoding: utf-8
class ChangeColumnQuestions < ActiveRecord::Migration[5.2]
  def change
    change_column :questions, :answered_at, :datetime, null: true, :comment => "回答日時"
  end
end
