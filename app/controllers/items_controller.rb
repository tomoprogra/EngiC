class ItemsController < ApplicationController
  before_action :correct_user
  before_action :set_user, only: [:index, :destroy, :create]
  before_action :note_api, only: [:index]

  def index
    @items = @user.mypage.items.order(:position)
    @item = @user.mypage.items.new
    @skill_list = @user.skills.map(&:name).join(", ")
    @skill = Skill.new
  end

  def create
    @item = @user.mypage.items.build(item_params)
    unless @item.save
      flash[:alert] = @item.errors.full_messages.to_sentence
    end
    redirect_to user_mypage_items_path(@user)
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

    def note_api
      note_items = @user.mypage.items.where.not(note_name: [nil, ""])

      return unless note_items.any?

      first_note_item = note_items.first
      creator_id = first_note_item.note_name

      @creator_info = NoteApiService.fetch_creator_info(creator_id)
      @note_count = @creator_info["data"]["noteCount"] if @creator_info && @creator_info["data"]
      @following_count = @creator_info["data"]["followingCount"] if @creator_info && @creator_info["data"]
      @follower_count = @creator_info["data"]["followerCount"] if @creator_info && @creator_info["data"]
    end

    def item_params
      params.require(:item).permit(:title, :content, :qiitaname, :zennname, :note_name, :imageurl, order: [])
    end

    def set_user
      @user = current_user
    end

    def correct_user
      @user = User.find(params[:user_id])
      unless @user == current_user
        flash[:alert] = "アクセス権限がありません。"
        redirect_to(root_url)
      end
    end
end
