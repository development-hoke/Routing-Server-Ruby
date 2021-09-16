# encoding: utf-8
class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions, :comment => "Q&A" do |t|
      t.text :question, null: false, :comment => "質問内容"
      t.text :answer, :comment => "回答内容"
      t.boolean :resolved, null: false, default: false, :comment => "解決済みかどうか"
      t.boolean :faq, null: false, default: false, :comment => "FAQかどうか"
      t.datetime :asked_at, null: false, :comment => "質問日時"
      t.datetime :answered_at, null: false, :comment => "回答日時"
      t.references :user, foreign_key: true, type: :string, limit: 36, null: false, :comment => "質問者のユーザーID"
    end

    set_table_comment :settings, "ユーザー設定"
  end
end
