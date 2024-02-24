# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  protect_from_forgery except: [:github, :twitter]

  def twitter
    authenticate_user_from_omniauth("twitter")
  end

  def github
    authenticate_user_from_omniauth("github")

    access_token = request.env["omniauth.auth"]["credentials"]["token"]
    # GitHubユーザー情報エンドポイント
    url = "https://api.github.com/user"
    # HTTPartyを使用してGETリクエスト
    response = HTTParty.get(url,
                            headers: {
                              "Authorization" => "token #{access_token}",
                              "User-Agent" => "engic.", # 実際のアプリ名に置き換えてください
                            })
    # レスポンスボディを解析（HTTPartyは自動的にJSONを解析してくれます）
    user_info = response.parsed_response
    # ユーザーアカウント名を取得
    username = user_info["login"]
    @user = current_user
    mypage = @user.mypage
    # contentがnilでないItemの中で最初のものを探す
    item = mypage.items.where.not(githubname: nil).first
    if item
      # 既に存在するItemがあれば、contentを更新
      item.update!(githubname: username)
    else
      # 存在しなければ、新しいItemを作成
      mypage.items.create!(githubname: username)
    end
  end

  def failure
    flash[:alert] = "error" 
    redirect_to root_path
  end

  private

    # def after_sign_in_path_for(resource)
    #   if resource.username.blank?
    #     edit_username_path
    #   else
    #     super
    #   end
    # end

    def authenticate_user_from_omniauth(provider)
      auth = request.env["omniauth.auth"]

      # 既にログインしている場合、新たな認証情報を紐付ける
      if user_signed_in?
        current_user.link_oauth_account(auth)
        set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
        redirect_to after_sign_in_path_for(current_user)
      else
        # ユーザー情報を取得し、検索または作成
        user = User.from_omniauth(auth)

        if user.persisted?
          sign_in_and_redirect user, event: :authentication
          set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
          session.delete("devise.#{provider}_data")
        else
          session["devise.#{provider}_data"] = request.env["omniauth.auth"].except("extra")
          redirect_to root_path
        end
      end
    end
end
