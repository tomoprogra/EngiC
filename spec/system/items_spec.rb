require "rails_helper"

RSpec.describe "Items", type: :system do
  let(:user) { create(:user) }

  before do
    visit root_path
    find(".btns", text: "ログイン").click
    click_button "Login/Sign up with X"
  end

  it "allows a user to create an item with qiitaname" do
    expect(page).to have_content("Twitter アカウントによる認証に成功しました。")
    expect(page).to have_current_path(user_mypage_path(User.last), ignore_query: true)
    click_link("編集")
    fill_in "item_qiitaname", with: "exampleuser"
    within(".qiitaname") do
      find(".btn-class").click
    end
    # # 確認：Itemが正常に作成されたかどうか
    expect(Item.where(qiitaname: "exampleuser").exists?).to be true
  end
end
