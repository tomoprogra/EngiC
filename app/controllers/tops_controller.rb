class TopsController < ApplicationController
  def index
    @user = current_user
    @resource = User.new
    @resource_name = :user
  end
end
