OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
  provider: "twitter",
  uid: "123545",
  info: {
    nickname: "testuser",
    email: "testuser@example.com",
    name: "testuser", # 実名が必要な場合
  },
  credentials: {
    token: "mock_token", # アクセストークン
    secret: "mock_secret", # アクセスシークレット（必要な場合）
  },
})
