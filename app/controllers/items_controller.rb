class ItemsController < ApplicationController
  def index
    @mypage = Mypage.find(params[:mypage_id])
    @items = Item.where(mypage_id: @mypage.id).order(:position)
    @item = Item.new
  end

  def create
    @mypage = Mypage.find(params[:mypage_id])
    @item = @mypage.items.build(item_params)
    if @item.save
      redirect_to mypage_items_path(@mypage)

    else
      format.html { render :index, status: :unprocessable_entity }
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy!
  end

  def save_order
    params[:order].each_with_index do |item_id, index|
      Item.find(item_id).update(position: index)
    end
    head :ok
  end

  private

    def item_params
      params.require(:item).permit(:title, :content, :qiitaname, order: [])
    end
end
