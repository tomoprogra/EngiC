class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:twitter, :github]
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
  VALID_USERNAMES = %w[admin root support help info mail contact user new edit index show create update delete error login logout signup users username
                       terms_of_use privacy_policy].freeze
  validates :username, presence: true, uniqueness: { case_sensitive: false },
                       exclusion: { in: VALID_USERNAMES, message: "(アカウント名)で%<value>s は使用できません。" }, length: { minimum: 2, maximum: 20 },
                       format: { with: /\A[a-zA-Z0-9_]+\z/, message: "(アカウント名)は英数字とアンダースコアのみ使用できます。" }
  validates :introduction, length: { maximum: 60 }
  
  def self.generate_unique_username
    loop do
      random_username = "user_#{SecureRandom.hex(4)}"
      break random_username unless User.exists?(username: random_username)
    end
  end

  def self.dummy_email(auth)
    "#{auth.uid}@#{auth.provider}.com"
  end

  def self.from_omniauth(auth)
    identity = Identity.find_or_initialize_by(provider: auth.provider, uid: auth.uid)
    identity.token = auth.credentials.token
    if identity.persisted?
      user = identity.user
    else
      user = User.find_or_initialize_by(email: auth.info.email || dummy_email(auth))
      if user.new_record?
        user.assign_attributes(
          name: auth.info.name,
          password: Devise.friendly_token[0, 20],
          remote_avatar_url: auth.info.image,
          username: generate_unique_username,
        )
        user.save!
      end
      identity.user = user
      identity.save!
    end
    user.handle_twitter_auth(auth) if auth.provider == "twitter"
    user
  end

  def handle_twitter_auth(auth)
    x_item_exists = self.mypage.items.where.not(xname: nil).exists?
    if x_item_exists
      self.update_x_if_changed(auth.info.nickname, auth.info.description, auth.info.location)
    else
      self.create_x_item(auth.info.nickname, auth.info.description, auth.info.location)
    end
  end

  def link_oauth_account(auth)
    identity = identities.find_or_initialize_by(provider: auth.provider, uid: auth.uid)
    identity.token = auth.credentials.token if auth.credentials.token.present?
    identity.save! if identity.new_record? || identity.changed?
    return unless auth.provider == "twitter"

    self.handle_twitter_auth(auth)
  end

  def follow(user_id)
    active_relationships.create(followed_id: user_id)
  end

  def unfollow(user_id)
    active_relationships.find_by(followed_id: user_id)&.destroy
  end

  def following?(user)
    following.include?(user)
  end

  def save_tags(sent_skills)
    current_skills = self.skills.pluck(:name)
    old_skills = current_skills - sent_skills
    new_skills = sent_skills - current_skills

    old_skills.each do |old_name|
      self.skills.delete(Skill.find_by(name: old_name))
    end

    new_skills.each do |new_name|
      new_skill = Skill.find_or_create_by!(name: new_name)
      self.skills << new_skill unless self.skills.include?(new_skill)
    end
  end

  def create_mypage
    build_mypage.save
  end

  def create_x_item(xname, bio, location)
    self.mypage.items.create(xname:, bio:, location:)
  end

  def update_x_if_changed(new_xname, new_bio, new_location)
    self.mypage || self.create_mypage
    x_item = self.mypage.items.find_or_initialize_by(xname: new_xname)
    x_item.xname = new_xname if x_item.xname != new_xname
    x_item.bio = new_bio if x_item.bio != new_bio
    x_item.location = new_location if x_item.location != new_location
    x_item.save! if x_item.changed?
  end
end
