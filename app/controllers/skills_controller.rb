class SkillsController < ApplicationController
  before_action :set_user, only: [:create, :destroy, :update]

  def create
    skill_list = params[:skill][:name].split(",").map(&:strip)
    if @user.save
      @user.save_tags(skill_list)
    else
      flash[:alert] = "スキルを設定できませんでした。"
    end
    redirect_to user_mypage_items_path(@user)
  end

  def destroy
    @user.skill.remove(skill_params)
    @user.save!
    redirect_to user_mypage_items_path(@user)
  end

  def update
    skill_list = params[:skill][:name].split(",").map(&:strip)
    if @user.update(skill_params)
      @user.save_tags(skill_list)
    else
      flash[:alert] = "スキルを更新できませんでした。"
    end
    redirect_to user_mypage_items_path(@user)
  end

  private

    def set_user
      @user = current_user
    end

    def skill_params
      params.require(:skill).permit(:name)
    end
end
