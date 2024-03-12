class Skill < ApplicationRecord
  has_many :skill_tags, dependent: :destroy
  # タグは複数の投稿を持つ　それは、post_tagsを通じて参照できる
  has_many :users, through: :skill_tags

  validates :name, uniqueness: true, presence: true
  validates :name, length: { maximum: 20 }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "name", "updated_at"]
  end
end
