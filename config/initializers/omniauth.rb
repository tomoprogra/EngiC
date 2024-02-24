Rails.application.config.middleware.use OmniAuth::Builder do
  OmniAuth.config.allowed_request_methods = [:post]

  provider :twitter, ENV["TWITTER_API_KEY"], ENV["TWITTER_SECRET_KEY"]
  provider :github, ENV["GITHUB_API_KEY"], ENV["GITHUB_SECRET_KEY"]
end
