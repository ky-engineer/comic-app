class HomeController < ApplicationController
  def home
    if current_user.nil?
      @posts = Post.order(created_at: :desc).paginate(page: params[:page])
    else
      @user = current_user
      @posts = current_user.feed.paginate(page: params[:page])
    end
  end
end
