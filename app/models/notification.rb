class Notification < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  enum period_type: { unspecified: 0, yearly: 10, monthly: 20 }
end
