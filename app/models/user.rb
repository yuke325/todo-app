class User < ApplicationRecord
  normalizes :email, with: ->(email) { email.strip.downcase }

  has_many :tasks, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true,
                    length: { maximum: 255 },
                    # 正規化表現への変換
                    format: { with: URI::MailTo::EMAIL_REGEXP },
                    uniqueness: { case_sensitive: false }
end
