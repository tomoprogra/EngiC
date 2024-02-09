class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]
  has_one :mypage, dependent: :destroy
  after_create :create_mypage
  mount_uploader :avatar, AvatarUploader

  def self.from_omniauth(auth)
    user = find_or_initialize_by(provider: auth[:provider], uid: auth[:uid])
    unless user.persisted?
      user.assign_attributes(
        name: auth[:info][:name],
        email: auth[:info][:email] || User.dummy_email(auth),
        password: Devise.friendly_token[0, 20],
        bio: auth[:info][:description],
        remote_avatar_url: auth[:info][:image], # 画像のURLを設定
      )
      user.save!
    end

    update_user_attributes(user, auth)
    user
  end

  def self.update_user_attributes(user, auth)
    attributes = {}
    attributes[:remote_avatar_url] = auth[:info][:image] if user.avatar.blank?
    attributes[:bio] = auth[:info][:description] if user.bio.blank?
    user.update!(attributes) if attributes.any?
  end

  private_class_method :update_user_attributes

  def self.new_with_session(_, session)
    super.tap do |user|
      if (data = session["devise.omniauth_data"])
        user.email = data["email"] if user.email.blank?
        user.provider = data["provider"] if data["provider"] && user.provider.blank?
        user.uid = data["uid"] if data["uid"] && user.uid.blank?

      end
    end
  end

  private

    def create_mypage
      Mypage.create(user: self)
    end
end
