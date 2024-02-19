class Identity < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }
  validates :token, presence: true
end
