class RelationshipsController < ApplicationController
  def index
    @user = current_user
  end

  def create
    @user = User.find_by(id: params[:user_id])
    @relationship = current_user.active_relationships.find_or_create_by!(followed_id: @user.id)
    current_user.follow(@user)
  end

  def destroy
    @relationship = current_user.active_relationships.find_by(id: params[:id])
    if @relationship
      @user = @relationship.followed
      @relationship.destroy!
    end
  end
end
