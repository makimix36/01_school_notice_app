class Notification < ApplicationRecord
  belongs_to :user
  #  has_one_attached :file
  has_many_attached :files

  validates :title, length: { maximum: 255 }
  validates :body, length: { maximum: 65535 }
  enum period_type: { unspecified: 0, yearly: 10, monthly: 20 }

  before_save :set_default_title

  #  validate :file_or_body_presence
  #  validate :acceptable_file_type
  validate :files_or_body_presence
  validate :acceptable_files_type

  private

  def set_default_title
    self.title = "no title" if title.blank?
  end

  def files_or_body_presence
    # !file.attached? を !files.attached? に変更
    if !files.attached? && body.blank?
      errors.add(:base, "ファイルまたは内容のいずれかを入力してください")
    end
  end

def acceptable_files_type
    # files.attached? に変更
    return unless files.attached?

    acceptable_types = %w[application/pdf image/jpeg image/png image/gif]

    # 変更点3: 複数ファイルそれぞれの content_type をチェックするように変更
    files.each do |file|
      unless acceptable_types.include?(file.content_type)
        errors.add(:files, "はPDF、JPG、JPEG、PNG、GIF形式のみアップロード可能です")
        break # 1つでもエラーがあれば抜ける
      end
    end
  end
end
