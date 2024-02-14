class ItemsController < ApplicationController
  def index
    @user = current_user
    @items = @user.mypage.items.order(:position)
    @item = Item.new
  end

  def create
    @user = current_user
    @item = @user.mypage.items.build(item_params)
    if @item.save
      redirect_to user_mypage_items_path(@user)
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
