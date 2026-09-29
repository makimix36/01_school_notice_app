class Notification < ApplicationRecord
  belongs_to :user
  has_one_attached :file

  validates :title, length: { maximum: 255 }
  validates :body, length: { maximum: 65535 }
  enum period_type: { unspecified: 0, yearly: 10, monthly: 20 }

  before_save :set_default_title
  validate :file_or_body_presence
  validate :acceptable_file_type

  private

  def set_default_title
    self.title = "no title" if title.blank?
  end

  def file_or_body_presence
    if !file.attached? && body.blank?
      errors.add(:base, "ファイルまたは内容のいずれかを入力してください")
    end
  end

  def acceptable_file_type
    return unless file.attached?

    acceptable_types = %w[application/pdf image/jpeg image/png image/gif]
    unless acceptable_types.include?(file.content_type)
      errors.add(:file, "はPDF、JPG、JPEG、PNG、GIF形式のみアップロード可能です")
    end
  end
end
