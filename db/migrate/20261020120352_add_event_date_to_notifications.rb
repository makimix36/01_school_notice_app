class AddEventDateToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_column :notifications, :event_date, :date
  end
end
