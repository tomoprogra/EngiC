class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_one :mypage, dependent: :destroy
  after_create :create_mypage

  private
  def create_mypage
    Mypage.create(user: self)
  end
end
