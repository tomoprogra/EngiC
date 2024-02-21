class Item < ApplicationRecord
  belongs_to :mypage
  validates :xname, uniqueness: true, allow_nil: true
  validates :githubname, uniqueness: true, allow_nil: true
  mount_uploader :imageurl, ImageUrlUploader
  validates :title, length: {maximum:60}
end