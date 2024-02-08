class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]
  has_one :mypage, dependent: :destroy
  after_create :create_mypage

  def self.from_omniauth(auth)
    where(uid: auth.uid).first
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

  private

    def create_mypage
      Mypage.create(user: self)
    end
end
