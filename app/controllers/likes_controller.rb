class LikesController < ApplicationController
  before_action :login_user

  def create
    @post = Post.find_by(id: params[:post_id])
    current_user.like_posts << @post
    redirect_to request.referrer || root_path
  end

  def destroy
    @post = Like.find_by(id: params[:id]).post
    current_user.like_posts.delete(@post)
    redirect_to request.referrer || root_path
  end
end
