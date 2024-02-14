class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter, :github]
  has_one :mypage, dependent: :destroy
  has_many :identities, dependent: :destroy
  # ユーザーがフォローしている人
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy, inverse_of: :follower
  has_many :following, through: :active_relationships, source: :followed
  # ユーザーをフォローしている人
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy, inverse_of: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  after_create :create_mypage
  mount_uploader :avatar, AvatarUploader

  def self.from_omniauth(auth)
    # 認証情報からIdentityを検索または作成
    identity = Identity.find_or_initialize_by(provider: auth.provider, uid: auth.uid)

    if identity.persisted?
      # Identityが見つかった場合、既存のユーザーを返す
      user = identity.user
    else
      # Identityが新しい場合、メールアドレスでユーザーを検索
      user = User.find_by(email: auth.info.email)

      if user.nil?
        # メールアドレスに該当するユーザーがいない場合、新規ユーザーを作成
        user = User.create!(
          email: auth.info.email || dummy_email(auth),
          name: auth.info.name,
          password: Devise.friendly_token[0, 20], # ランダムなパスワードを生成
          bio: auth[:info][:description],
          remote_avatar_url: auth[:info][:image], # 画像のURLを設定
        )
      end

      # 新しい認証情報を既存または新規のユーザーに紐づける
      identity.user = user
      identity.save!
    end

    # ユーザーの追加属性を更新（必要に応じて）
    update_user_attributes(user, auth)

    user
  end

  def self.update_user_attributes(user, auth)
    # 更新するユーザー属性を決定。例: 名前や画像が未設定の場合のみ更新
    user.name = auth.info.name if user.name.blank?
    user.remote_avatar_url = auth.info.image if user.remote_avatar_url.blank?
    # bioやその他の属性があれば、同様の条件で更新
    user.save! if user.changed?
  end

  def self.dummy_email(auth)
    "#{auth[:uid]}@example.com"
  end

  def link_oauth_account(auth)
    identity = Identity.find_or_create_by!(provider: auth.provider, uid: auth.uid)
    if identity.user != self
      identity.update!(user: self)
    end
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

  private

    def create_mypage
      Mypage.create(user: self)
    end
end
