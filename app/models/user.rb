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


  def link_oauth_account(auth)
    # 認証プロバイダとUIDでIdentityを検索、または新規作成
    identity = identities.find_or_initialize_by(provider: auth.provider, uid: auth.uid)

    # 必要な情報を更新
    identity.token = auth.credentials.token if auth.credentials.token.present?
    
    # Identityを保存
    identity.save if identity.new_record? || identity.changed?
    if auth.provider == 'twitter'
      username = auth.info.nickname # またはauth.info.username
      x_item_exists = self.mypage.items.where.not(xname: nil).exists?
      unless x_item_exists
        self.create_x_item(username, auth.info.description, auth.info.location)
      else
        self.update_x_if_changed(username, auth.info.description, auth.info.location)
      end
    end
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

  # bio情報を含むitemを作成するメソッド
  def create_x_item(xname, bio, location)
    self.mypage.items.create(xname: xname, bio: bio, location: location)
  end


  def self.from_omniauth(auth)
    # Identityの処理はそのまま
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
        )
        user.save!
      end
      identity.user = user
      identity.save!
    end
    if auth.provider == 'twitter'
      username = auth.info.nickname # またはauth.info.username
      x_item_exists = user.mypage.items.where.not(xname: nil).exists?
      unless x_item_exists
        user.create_x_item(username, auth.info.description, auth.info.location)
      else
        user.update_x_if_changed(username, auth.info.description, auth.info.location)
      end
    end
    user
  end
  

  def self.update_user_info(user, auth)
    # プロバイダーごとに取得する情報を分岐
    case auth.provider
    when 'twitter'
      # Twitterからはbio, username, locationを更新
      user.twittername = auth.info.username if user.username.blank? && auth.info.username.present?
      user.bio = auth.info.description if auth.info.description.present?
      user.location = auth.info.location if user.location.blank? && auth.info.location.present?
      user.save! if user.changed?
    end
  end

  def update_x_if_changed(new_xname, new_bio, new_location)
    # mypageがnilでないことを保証する
    mypage = self.mypage || self.create_mypage
    
    x_item = self.mypage.items.find_or_initialize_by(xname: new_xname)
    
    # xname、bio、locationの変更がある場合にのみ更新
    x_item.xname = new_xname if x_item.xname != new_xname
    x_item.bio = new_bio if x_item.bio != new_bio
    x_item.location = new_location if x_item.location != new_location
  
    # 変更があった場合のみ保存
    x_item.save if x_item.changed?
  end
end