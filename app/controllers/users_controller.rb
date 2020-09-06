class UsersController < ApplicationController
  before_action :login_user, only: [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy


  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.image.attach(params[:user][:image])
    if @user.save
      flash[:success] = "ユーザー登録が完了しました。"
      redirect_to user_path(@user)
    else
      render "new"
    end

  end

  def show
    @user = User.find_by(id: params[:id])
    @posts = @user.posts.paginate(page: params[:page])
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    @user.image.attach(params[:user][:image]) unless params[:user][:image].nil?
    if @user.update(user_params)
      flash[:success] = "ユーザー情報を更新しました"
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    if @user.destroy
      flash[:success] = "#{@user.name.inspect}のユーザー情報を削除しました"
      redirect_to users_path
    else
      flash[:danger] = "#{@user.name.inspect}のユーザー情報の削除に失敗しました"
      render 'users/index'
    end
  end

  private

  #Strong Parametersを適用するためのメソッド
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :image)
  end


  # before_action用のメソッド


  # ログインしているユーザーと編集対象のユーザーが一致するかどうか
  def correct_user
    @user = User.find_by(id: params[:id])
    unless @user == current_user
      flash[:warning] = "権限がありません"
      redirect_to root_path
    end
  end

  # ログインしているユーザーが管理者かどうか
  def admin_user
    unless current_user && current_user.admin == true
      flash[:warning] = "権限がありません"
      redirect_to root_path
    end
  end

end
