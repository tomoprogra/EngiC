class TopsController < ApplicationController
  def index
    @user = current_user
    @resource = User.new
    @resource_name = :user
  end

  def privacy_policy
  end

  def terms_of_use
  end
end
