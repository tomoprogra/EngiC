class ItemsController < ApplicationController
  before_action :set_user, only: [:index, :create_or_update_item, :destroy]

  def index
    @items = @user.mypage.items.order(:position)
    @item = @user.mypage.items.new
    @skill_list = @user.skills.map(&:name).join(", ")
    @skill = Skill.new
  end

  def create_or_update_item
    field_name = params[:item][:field_name]
    field_value = params[:item][field_name]
    item = @user.mypage.items.find_or_initialize_by("#{field_name}": field_value)
    item.assign_attributes(item_params)

    if item.save
      message = item.persisted? ? "Item was successfully updated." : "New item was successfully created."
      redirect_to user_mypage_items_path(@user), notice: message
    else
      render :new, status: :unprocessable_entity
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
