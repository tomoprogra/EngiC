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

  def following
    @user = User.find(params[:id])
    @users = @user.following
    render "show_follow"
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers
    render "show_follow"
  end

  private

    def set_user
      @user = current_user
    end

    def user_params
      params.require(:user).permit(:name, :introduction)
    end
end
