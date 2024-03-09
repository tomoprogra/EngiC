RSpec.describe "Twitter Authentication", type: :system do
  it "can log in user with Twitter account" do
    visit user_twitter_omniauth_callback_path # パスはアプリケーションによって異なる場合があります

    # Twitterでの認証を模擬
    expect(page).to have_content("testuser") # モックから返される情報を検証
  end
end
