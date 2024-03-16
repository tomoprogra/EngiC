class Item < ApplicationRecord
  belongs_to :mypage
  validates :xname, uniqueness: true, allow_nil: true
  validates :githubname, uniqueness: true, allow_nil: true
  mount_uploader :imageurl, ImageUrlUploader
  validates :title, length: { maximum: 40 }
  # validates :qiitaname, format: { with: /\A[A-Za-z0-9_]+\z/, message: "はアルファベット、数字、アンダースコアのみ使用できます" }
  # validates :zennname, format: { with: /\A[A-Za-z0-9_]+\z/, message: "はアルファベット、数字、アンダースコアのみ使用できます" }
  # validates :note_name, format: { with: /\A[A-Za-z0-9_]+\z/, message: "はアルファベット、数字、アンダースコアのみ使用できます" }
end
