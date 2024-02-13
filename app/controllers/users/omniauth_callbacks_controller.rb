# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  protect_from_forgery :except => [:github, :twitter]
  
  def twitter
    authenticate_user_from_omniauth("twitter")
  end

  def github
    authenticate_user_from_omniauth("github")
  end

  def upgrade
    provider = params[:provider]
    scope = nil # 必要に応じて設定
  
    # 動的にパスを生成する
    redirect_to send("user_#{provider}_omniauth_authorize_path", scope: scope)
  end
  
  private

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
        session["devise.#{provider}_data"] = request.env["omniauth.auth"].auth.except(:extra)
        redirect_to new_user_registration_url
      end
    end
  end
end
