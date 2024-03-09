require "rails_helper"

RSpec.describe "Items", type: :system do
  let(:user) { create(:user) } 
  
  before do
    visit root_path
    find(".btns", text: "ログイン").click
    click_button "Login/Sign up with X"
    # visit user_mypage_path(user)
  end

  it "allows a user to create an item with qiitaname" do
    expect(page).to have_content('Twitter アカウントによる認証に成功しました。')
    expect(current_path).to eq(user_mypage_path(User.last))
    click_link('編集')
    fill_in "item_qiitaname", with: "exampleuser"
    within(".qiitaname") do
      find(".btn-class").click
    end
    # # 確認：Itemが正常に作成されたかどうか
    expect(Item.where(qiitaname: "exampleuser").exists?).to be true
  end
end
 # # 特定のタブ（例えば「記事」）をクリック

    # # タブのコンテンツが表示されるのを待つ
    # 

    # # qiitanameの入力
    

    # # フォーム内のsubmitボタンを探してクリック
    # 