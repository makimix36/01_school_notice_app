class User < ApplicationRecord
  has_secure_password
  before_validation :set_default_nickname
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:password_digest] }
  validates :nickname, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true

  private

  def set_default_nickname
    self.nickname = 'no name' if nickname.blank?
  end  
end
