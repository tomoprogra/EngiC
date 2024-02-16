class MypagesController < ApplicationController
  def show
    @user = User.find(params[:user_id])
    @items = @user.mypage.items.order(:position)
    @skill_list = @user.skills.map(&:name).join(", ")
  end
end
