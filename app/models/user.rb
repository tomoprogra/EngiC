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
    
    provider = auth[:provider]
      uid = auth[:uid]
      user_name = auth[:info][:name]
      image_url = auth[:info][:image]
      bio = auth[:info][:description]
      email = auth[:info][:email] || User.dummy_email(auth)
      password = Devise.friendly_token[0, 20]
      
      user = find_or_create_by(provider: provider, uid: uid) do |user|
        user.name = user_name
        user.email = email
        user.password = password
        user.bio = bio
        # CarrierWaveを使用して画像をアップロード
        user.remote_avatar_url = image_url # 外部URLから画像をアップロード
      end
  
      if user.persisted? && user.avatar.blank?
        # ユーザーが既に存在するが、アバターが設定されていない場合
        user.remote_avatar_url = image_url
        user.save
      end
      
      if user.persisted? && user.bio.blank?
        user.update(bio: bio) unless user.bio
      end

      user
  end

  def self.new_with_session(_, session)
    super.tap do |user|
      if (data = session['devise.omniauth_data'])
        user.email = data['email'] if user.email.blank?
        user.provider = data['provider'] if data['provider'] && user.provider.blank?
        user.uid = data['uid'] if data['uid'] && user.uid.blank?
        
      end
    end
  end

  # class << self
  #   def find_for_oauth(auth)
  #     provider = auth[:provider]
  #     uid = auth[:uid]
  #     user_name = auth[:info][:name]
  #     image_url = auth[:info][:image]
  #     email = User.dummy_email(auth)
  #     password = Devise.friendly_token[0, 20]
      
  #     user = find_or_create_by(provider: provider, uid: uid) do |user|
  #       user.name = user_name
  #       user.email = email
  #       user.password = password
  #       # CarrierWaveを使用して画像をアップロード
  #       user.remote_avatar_url = image_url # 外部URLから画像をアップロード
  #     end
  
  #     if user.persisted? && user.avatar.blank?
  #       # ユーザーが既に存在するが、アバターが設定されていない場合
  #       user.remote_avatar_url = image_url
  #       user.save
  #     end
  
  #     user
  #   end
  # end
  


  private

    def create_mypage
      Mypage.create(user: self)
    end
end
