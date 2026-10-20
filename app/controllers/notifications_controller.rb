class NotificationsController < ApplicationController
  before_action :set_notification, only: [ :show, :edit, :update, :destroy ]
def index
    # .with_attached_files の代わりに以下を使用します
    @notifications = current_user.notifications.includes(files_attachments: :blob)
  end

  def new
    @notification = Notification.new
  end

  def show
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
  end

  def update
    # 1. パラメーターを変数に格納
    safe_params = notification_params

    # 2. 自動で上書きされてしまうのを防ぐため、ファイル関連のパラメータを取り除く
    new_files = safe_params.delete(:files)
    file_ids_to_delete = safe_params.delete(:file_ids_to_delete)
    # 3. まずはテキスト等（ファイル以外）を更新
    if @notification.update(safe_params)

      # 4. 新しいファイルが選択されていれば、既存ファイルに「追加（attach）」する
      @notification.files.attach(new_files) if new_files.present?
      # 5. 「削除」にチェックがついたファイルがあれば、そのファイルを削除（purge）する
      if file_ids_to_delete.present?
        file_ids_to_delete.each do |file_id|
          @notification.files.find(file_id).purge
        end
      end
      redirect_to notification_path(@notification), notice: "更新しました"
    else
      flash.now[:alert] = "更新に失敗しました\n#{@notification.errors.full_messages.join("\n")}"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @notification.destroy!
    redirect_to notifications_path, notice: "削除しました"
  end

  private
  def set_notification
    #    @notification = current_user.notifications.find(params[:id])
    @notification = current_user.notifications.includes(files_attachments: :blob).find(params[:id])
  end

  def notification_params
    params.require(:notification).permit(:title, :body, :deadline, :event_date, :period_type, :is_important, :is_submission, :is_document, files: [], file_ids_to_delete: [])
  end
end
