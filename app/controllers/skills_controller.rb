class SkillsController < ApplicationController
  before_action :set_user

  def create
    skill_list=params[:skill][:name].split(',').map(&:strip)
    if@user.save
      @user.save_tags(skill_list)
      redirect_to user_mypage_items_path(@user)
    else
      flash[:alert] = できてない
      redirect_to user_mypage_items_path(@user)
    end
  end

  def destroy
    @user.skill.remove(skill_params)
    @user.save
    redirect_to user_mypage_items_path(@user)
  end

  def update
    skill_list=params[:skill][:name].split(',').map(&:strip)
    if @user.update(skill_params)
      @user.save_tags(skill_list)
      redirect_to user_mypage_items_path(@user), notice: 'Skills were successfully updated.'
    else
      flash[:alert] = できてない
      redirect_to user_mypage_items_path(@user)
    end
  end
  
  private

  def set_user
    @user = current_user
  end

  def skill_params
    params.require(:skill).permit(:name)
  end
end

