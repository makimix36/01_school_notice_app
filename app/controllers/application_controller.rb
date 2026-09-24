class ApplicationController < ActionController::Base
  before_action :require_login
  rescue_from ActiveRecord::RecordNotFound, with: :render_404_or_redirect
  def render_404_or_redirect
    redirect_to notifications_path, alert: "指定されたお知らせが見つかりませんでした"
  end

  add_flash_types :success, :danger
end
