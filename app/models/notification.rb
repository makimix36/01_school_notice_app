class Notification < ApplicationRecord
  belongs_to :user
  has_one_attached :file

  enum period_type: { unspecified: 0, yearly: 10, monthly: 20 }

  before_save :set_default_title
  validate :file_or_body_presence

  private

  def set_default_title
    self.title = "no title" if title.blank?
  end

  def file_or_body_presence
    if !file.attached? && body.blank?
      errors.add(:base, "ファイルまたは内容のいずれかを入力してください")
    end
  end
end
