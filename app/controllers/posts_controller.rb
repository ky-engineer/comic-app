class PostsController < ApplicationController
  before_action :login_user, only: [:new, :create, :destroy]
  before_action :correct_user, only: :destroy

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "投稿しました"
      redirect_to root_path
    else
      render 'posts/new'
    end
  end

  def destroy
    @post = current_user.posts.find_by(id: params[:id])
    if @post.destroy
      flash[:success] = "投稿を削除しました"
      redirect_to request.referrer || root_path
    else
      flash[:danger] = "投稿の削除に失敗しました"
      render 'users/show'
    end
  end

  private

  #Strong Parametersを適用するためのメソッド
  def post_params
    params.require(:post).permit(:title, :content, :picture_url)
  end

  # before_action用のメソッド
  # 正しいユーザーかどうか
  def correct_user
    @post = current_user.posts.find_by(id: params[:id])
    if @post.nil?
      flash[:warning] = "権限がありません"
      redirect_to root_path
    end
  end

end
