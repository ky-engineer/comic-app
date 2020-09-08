class RelationshipsController < ApplicationController
  before_action :login_user

  def create
    @user = User.find_by(id: params[:followed_id])
    current_user.following << @user
    redirect_to user_path(@user)
  end

  def destroy
    @user = Relationship.find_by(id: params[:id]).followed
    current_user.following.delete(@user)
    redirect_to user_path(@user)
  end
end
