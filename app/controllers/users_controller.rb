class UsersController < ApplicationController
  before_action :set_user, only: [:update, :edit, :destroy]
  before_action :authenticate_user!

  def edit
  end

  def index
    @users = User.includes([:skills]).all
  end

  def update
    unless @user.update(user_params)
      redirect_to user_mypage_items_path(@user), status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      redirect_to root_url, notice: "アカウントが正常に削除されました。"
    else
      redirect_to root_url, alert: "アカウントの削除に失敗しました。"
    end
  end

  def edit_username
    @user = current_user
  end

  def update_username
    @user = current_user
    if @user.update(user_params)
      redirect_to root_path, notice: "Your username was successfully updated."
    else
      render :edit_username
    end
  end

  def resolve_username
    user = User.find_by(username: params[:username])
    if user
      redirect_to user_mypage_path(user_id: user.id)
    else
      redirect_to root_path
    end
  end

  def show_follows
    @user = User.find(params[:id])
    @following = @user.following
    @followers = @user.followers
  end

  private

    def set_user
      @user = current_user
    end

    def user_params
      params.require(:user).permit(:username, :name, :introduction)
    end
end
