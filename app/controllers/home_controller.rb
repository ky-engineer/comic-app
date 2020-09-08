class HomeController < ApplicationController
  def home
    unless current_user.nil?
      @user = current_user
      @posts = current_user.feed.paginate(page: params[:page])
    end
  end
end
