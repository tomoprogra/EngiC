class MypagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  require "rqrcode"
  before_action :set_user, only: [:show, :qrcode]
  before_action :note_api, only: [:show]

  def show
    @items = @user.mypage.items.order(:position)
    @skill_list = @user.skills.map(&:name).join(", ")
    @user = User.find(params[:user_id])
    if current_user
      @relationship = current_user.active_relationships.find_by(followed_id: @user.id)
    end
  end

  def qrcode
    if @user
      url = "https://engic.dev/#{@user.username}"
      @qr = RQRCode::QRCode.new(url)

      respond_to do |format|
        format.html # app/views/mypages/qrcode.html.erb をレンダリング
        format.png do
          send_data @qr.as_png(size: 200).to_s, type: "image/png", disposition: "inline"
        end
      end
    else
      render file: "public/404.html", status: :not_found, layout: false
    end
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

    def set_user
      @user = User.find(params[:user_id])
    end
end
