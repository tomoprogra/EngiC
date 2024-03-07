require "rails_helper"

RSpec.describe User, type: :model do
  # 有効なファクトリを持つこと
  it "has a valid factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  # ユーザー名がなければ無効な状態であること
  it "is invalid without an username" do
    user = FactoryBot.build(:user, username: nil)
    user.valid?
    expect(user.errors[:username]).to include("を入力してください")
  end

  # パスワードがなければ無効な状態であること
  it "is invalid without a password" do
    user = FactoryBot.build(:user, password: nil)
    user.valid?
    expect(user.errors[:password]).to include("を入力してください")
  end

  # メールアドレスがなければ無効な状態であること
  it "is invalid without an email address" do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("を入力してください")
  end

  # 重複したユーザー名なら無効な状態であること
  it "is invalid with a duplicate username" do
    FactoryBot.create(:user, username: "tomo")
    user = FactoryBot.build(:user, username: "tomo")
    user.valid?
    expect(user.errors[:username]).to include("はすでに存在します")
  end

  # 重複したメールアドレスなら無効な状態であること
  it "is invalid with a duplicate email" do
    FactoryBot.create(:user, email: "aaron@example.com")
    user = FactoryBot.build(:user, email: "aaron@example.com")
    user.valid?
    expect(user.errors[:email]).to include("はすでに存在します")
  end
end
