class RelationshipsController < ApplicationController

  def index
    @user = current_user
  end

  def create
    current_user.follow(params[:followed_id])
    redirect_to request.referer
  end

  def destroy
    relationship = current_user.active_relationships.find_by(id: params[:id])
    relationship.destroy! if relationship
    redirect_to request.referer || root_path
  end

  def follower
    user = User.find(params[:user_id])
    @users = user.followers
  end

  def followed
    user = User.find(params[:user_id])
    @users = user.following
  end
end
