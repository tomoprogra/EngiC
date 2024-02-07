class ItemsController < ApplicationController
  def index
    @mypage = Mypage.find(params[:mypage_id])
    @items = Item.where(mypage_id: @mypage.id)
    @item = Item.new
  end

  def create
    @mypage = Mypage.find(params[:mypage_id])
    @item = @mypage.items.build(item_params)
    # @items = Item.where(user_id: current_user.id)
    respond_to do |format|
      if @item.save
        format.turbo_stream
        format.html { redirect_to mypage_items_path(@mypage) }
      else
        format.html { render :index, status: :unprocessable_entity }
      end
    end
  end

  private

    def item_params
      params.require(:item).permit(:title, :content)
    end
end
