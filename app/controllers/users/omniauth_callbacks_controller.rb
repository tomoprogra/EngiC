# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :authenticate_user!
  include OmniauthCallbacksHelper
  protect_from_forgery except: [:github, :twitter]

  def twitter
    authenticate_user_from_omniauth("twitter")
  end

  def github
    authenticate_user_from_omniauth("github")
    access_token = request.env["omniauth.auth"]["credentials"]["token"]
    user_info = fetch_github_user_info(access_token)
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
      begin
        mypage.items.create!(githubname: username)
      rescue ActiveRecord::RecordInvalid
        # Itemの作成に失敗した場合、エラーメッセージを設定
      end
    end
  end

  def failure
    flash[:alert] = omniauth_failure_message
    redirect_to root_path
  end

  def authenticate_user_from_omniauth(provider)
    auth = request.env["omniauth.auth"]

    if user_signed_in?
      link_oauth_account_to_current_user(auth, provider)
    else
      authenticate_new_or_unlogged_user(auth, provider)
    end
  end

  private

    def fetch_github_user_info(access_token)
      url = "https://api.github.com/user"
      response = HTTParty.get(url,
                              headers: {
                                "Authorization" => "token #{access_token}",
                                "User-Agent" => "engic.",
                              })
      # レスポンスボディを解析（HTTPartyは自動的にJSONを解析してくれます）
      response.parsed_response
    end

    def link_oauth_account_to_current_user(auth, provider)
      current_user.link_oauth_account(auth)
      set_flash_message_and_redirect(:notice, :success, provider)
    rescue ActiveRecord::RecordInvalid => e
      handle_oauth_error(provider, e)
    end

    def authenticate_new_or_unlogged_user(auth, provider)
      user = User.from_omniauth(auth)

      if user.persisted?
        sign_in_and_redirect user, event: :authentication
        set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
      else
        prepare_for_new_user_registration(auth, provider)
      end
    end

    def set_flash_message_and_redirect(type, status, provider)
      set_flash_message(type, status, kind: provider.capitalize) if is_navigational_format?
      redirect_to after_sign_in_path_for(current_user)
    end

    def handle_oauth_error(provider, exception)
      set_flash_message(:alert, :failure, kind: provider.capitalize, reason: exception.record.errors.full_messages.join(", ")) if is_navigational_format?
      redirect_to after_sign_in_path_for(current_user)
    end

    def prepare_for_new_user_registration(auth, provider)
      session["devise.#{provider}_data"] = auth.except("extra")
      redirect_to root_path
    end
end
