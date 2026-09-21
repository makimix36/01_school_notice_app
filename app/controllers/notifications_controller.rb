class NotificationsController < ApplicationController
  def new
    @notification = Notification.new
  end
  def create
    @notification = current_user.notifications.build(notification_params)
    if @notification.save
      redirect_to root_path, notice: "お知らせを作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end
end
private

def notification_params
  params.require(:notification).permit(:title, :body, :deadline, :is_important, :is_submission, :is_document, :period_type, :image)
end
