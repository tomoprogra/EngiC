class UsersController < ApplicationController
  before_action :set_user, only: [:update, :edit]

  def edit
  end

  def update
    if @user.update(user_params)
      flash.now.notice = "ユーザーを更新しました。"
    else
      redirect_to user_mypage_items_path(@user), status: :unprocessable_entity
    end
  end

  private

    def set_user
      @user = current_user
    end

    def user_params
      params.require(:user).permit(:name, :introduction)
    end
end
