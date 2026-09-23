class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.includes(:user)
  end

  def new
    @notification = Notification.new
  end

  def show
    @notification = Notification.find(params[:id])
  end

  def create
    @notification = current_user.notifications.build(notification_params)
    if @notification.save
      redirect_to notifications_path, notice: "お知らせを作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @notification = current_user.notifications.find(params[:id])
  end

  def update
    @notification = current_user.notifications.find(params[:id])

    if @notification.update(notification_params)
      redirect_to notification_path(@notification), notice: "更新しました"
    else
      flash.now[:alert] = "更新に失敗しました\n#{@notification.errors.full_messages.join("\n")}"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    notification = current_user.notifications.find(params[:id])
    notification.destroy!
    redirect_to notifications_path, notice: "削除しました"
  end

  private

  def notification_params
    params.require(:notification).permit(:title, :body, :deadline, :is_important, :is_submission, :is_document, :period_type, :file)
  end
end
