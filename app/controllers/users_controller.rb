class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:resolve_username]
  before_action :set_user, only: [:update, :edit, :destroy]
  helper_method :associated_skills_for_select

  def edit; end

  def index
    adjust_search_parameters_for_case_insensitivity(params[:q])
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).preload(:skills).page(params[:page]).per(20)
    @skills = associated_skills_for_select
  end

  def search
    @users = User.select("DISTINCT name").
               where("LOWER(name) LIKE ?", "%#{params[:q].downcase}%").
               limit(5)
    render partial: "users/search", locals: { users: @users }
  end

  def update
    unless @user.update(user_params)
      flash.now.alert = @user.errors.full_messages.to_sentence
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
      redirect_to user_mypage_items_path(@user), notice: "アカウント名が更新されました。"
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :edit_username, status: :unprocessable_entity
    end
  end

  def resolve_username
    user = User.find_by(username: params[:username])
    if user
      redirect_to user_mypage_path(user_id: user.id)
    else
      flash[:alert] = "ページが見つかりませんでした。"
      redirect_to root_path
    end
  end

  def show_following
    @user = User.find(params[:id])
    @following = @user.following.includes(:skills).page(params[:page]).per(16)
  end

  def show_followers
    @user = User.find(params[:id])
    @followers = @user.followers.includes(:skills).page(params[:page]).per(16)
  end

  private

    def set_user
      @user = current_user
    end

    def user_params
      params.require(:user).permit(:username, :name, :introduction)
    end

    def associated_skills_for_select
      Skill.joins(:users).distinct.pluck("LOWER(skills.name)").uniq
    end

    def adjust_search_parameters_for_case_insensitivity(search_params)
      if search_params && search_params[:skills_name_eq].present?
        search_params[:skills_name_eq] = search_params[:skills_name_eq].downcase
        search_params[:skills_name_cont] = search_params.delete(:skills_name_eq)
      end
    end
end
