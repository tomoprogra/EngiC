class TopsController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    @user = current_user
    @resource = User.new
    @resource_name = :user
  end

  def privacy_policy; end

  def terms_of_use; end

  def release_note; end
end
