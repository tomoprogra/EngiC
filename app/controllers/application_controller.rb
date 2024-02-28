class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  def after_sign_in_path_for(current_user)
    user_mypage_path(current_user)
  end

  private

    def authenticate_user!
      unless user_signed_in?
        flash[:alert] = "ログインが必要な機能です。"
        redirect_to root_path
      end
    end
end
