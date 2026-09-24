class ChangeDefaultValueOfTitleToNotifications < ActiveRecord::Migration[7.1]
  def change
    change_column_default :notifications, :title, from: "no title", to: nil
  end
end
