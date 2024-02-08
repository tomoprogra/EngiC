class ItemsController < ApplicationController
  def index
    @mypage = Mypage.find(params[:mypage_id])
    @items = Item.where(mypage_id: @mypage.id)
    @item = Item.new
  end

  def create
    @mypage = Mypage.find(params[:mypage_id])
    respond_to do |format|
      @item = @mypage.items.build(item_params)
      if @item.save
        redirect_to mypage_items_path(@mypage)
        format.turbo_stream
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
