class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, default: "no title", null: false
      t.text :body
      t.date :deadline
      t.integer :period_type, default: 0, null: false
      t.boolean :is_important, default: false, null: false
      t.boolean :is_submission, default: false, null: false
      t.boolean :is_document, default: false, null: false

      t.timestamps
    end
  end
end
