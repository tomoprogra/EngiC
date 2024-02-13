class MypagesController < ApplicationController
  def show
    @mypage = Mypage.find(params[:id])
    @user = @mypage.user
    @items = Item.where(mypage_id: @mypage.id).order(:position)
  end
end
