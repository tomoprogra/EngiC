class UsersController < ApplicationController
  before_action :set_user, only: [:update, :edit]
  before_action :authenticate_user!

  def resolve_username
    # ユーザー名からユーザーを検索
    user = User.find_by(username: params[:username])

    if user
      # ユーザーが見つかった場合、ユーザーIDに基づくページにリダイレクト
      redirect_to user_mypage_path(user_id: user.id)
    else
      # ユーザーが見つからない場合、適切なエラーページにリダイレクト
      redirect_to not_found_path
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
      params.require(:user).permit(:username, :name, :introduction)
    end
end
