class ApplicationController < ActionController::Base
  def after_sign_in_path_for(current_user)
    user_mypage_items_path(current_user)
  end
end
