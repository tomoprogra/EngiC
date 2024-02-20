class Item < ApplicationRecord
  belongs_to :mypage
  validates :xname, uniqueness: true, allow_nil: true
  validates :githubname, uniqueness: true, allow_nil: true
end
