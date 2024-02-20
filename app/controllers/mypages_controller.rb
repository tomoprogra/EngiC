class MypagesController < ApplicationController
  require "rqrcode"

  def show
    @user = User.find(params[:user_id])
    @items = @user.mypage.items.order(:position)
    @skill_list = @user.skills.map(&:name).join(", ")
  end

  def qrcode
    @user = User.find(params[:user_id])

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
end
