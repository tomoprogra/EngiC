class ItemsController < ApplicationController
  before_action :set_user, only: [:index, :destroy, :create]

  def index
    @items = @user.mypage.items.order(:position)
    @item = @user.mypage.items.new
    @skill_list = @user.skills.map(&:name).join(", ")
    @skill = Skill.new
  end

  def create
    @item = @user.mypage.items.build(item_params)
    if @item.save
      redirect_to user_mypage_items_path(@user)
    else
      flash[:alert] = @item.errors.full_messages.to_sentence
      redirect_to user_mypage_items_path(@user), status: :unprocessable_entity
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
      params.require(:item).permit(:title, :content, :qiitaname, :zennname, order: [])
    end

    def set_user
      @user = current_user
    end
end
