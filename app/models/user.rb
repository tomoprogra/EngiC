class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:twitter, :github]
  has_one :mypage, dependent: :destroy
  has_many :identities, dependent: :destroy
  # ユーザーがフォローしている人
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy, inverse_of: :follower
  has_many :following, through: :active_relationships, source: :followed
  # ユーザーをフォローしている人
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy, inverse_of: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :skill_tags, dependent: :destroy
  has_many :skills, through: :skill_tags
  after_create :create_mypage
  mount_uploader :avatar, AvatarUploader

  def self.from_omniauth(auth)
    identity = Identity.find_or_initialize_by(provider: auth.provider, uid: auth.uid)

    if identity.persisted?
      # Identityが見つかった場合、既存のユーザーを返す
      user = identity.user
    else
      # Identityが新しい場合、メールアドレスでユーザーを検索
      user = User.find_or_initialize_by(email: auth.info.email || dummy_email(auth))
      if user.new_record?
        user.assign_attributes(
          name: auth.info.name,
          password: Devise.friendly_token[0, 20], # ランダムなパスワードを生成
          bio: auth.info.description, # Twitterから取得したbioを設定
          remote_avatar_url: auth.info.image, # 画像のURLを設定
        )
        user.save!
        user.create_bio_item(auth.info.description) # bio情報を含むitemを作成
      end
      identity.user = user
      identity.save!
    end
    user.update_bio_if_changed(auth.info.description)
    user
  end

  # ダミーメールアドレスの生成
  def self.dummy_email(auth)
    "#{auth.uid}@#{auth.provider}.com"
  end

  # ユーザーをフォローする
  def follow(user_id)
    active_relationships.create(followed_id: user_id)
  end

  # ユーザーのフォローを解除する
  def unfollow(user_id)
    active_relationships.find_by(followed_id: user_id)&.destroy
  end

  # 指定されたユーザーをフォローしているかどうかをチェックする
  def following?(user)
    following.include?(user)
  end

  def save_tags(sent_skills)
    current_skills = self.skills.pluck(:name)
    old_skills = current_skills - sent_skills
    new_skills = sent_skills - current_skills

    # 古いスキルを削除
    old_skills.each do |old_name|
      self.skills.delete(Skill.find_by(name: old_name))
    end

    # 新しいスキルを追加
    new_skills.each do |new_name|
      new_skill = Skill.find_or_create_by!(name: new_name)
      self.skills << new_skill unless self.skills.include?(new_skill)
    end
  end

  def create_mypage
    build_mypage.save
  end

  def update_bio_if_changed(new_bio)
    if self.bio != new_bio
      self.bio = new_bio
      save!
      update_bio_item(new_bio)
    end
  end

  # bio情報を含むitemを更新または作成するメソッド
  def update_bio_item(new_bio)
    bio_item = mypage.items.where.not(bio: nil).first
    bio_item.bio = new_bio
    bio_item.save!
  end

  # bio情報を含むitemを作成するメソッド
  def create_bio_item(new_bio)
    mypage.items.create(bio: new_bio)
  end
end
