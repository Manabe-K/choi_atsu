class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  def index
    @users = User.all
  end

  def show
  end

  def new
    unless session[:user_registration]
      redirect_to root_path, alert: "不正なアクセスです。"
      return
    end

    @user = User.new(session[:user_registration])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session.delete(:user_registration)
      session[:user_id] = @user.id
      redirect_to events_path, notice: "ユーザー登録が完了しました。"
    else
      render :new
    end
  end

  def edit
    # ここでユーザーを取得するので、ログイン済みのユーザーが編集対象となる
    # ログインユーザーの情報を編集する場合、current_user で取得する方法もあり
    @user = current_user
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "ユーザー情報が更新されました。"
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: "ユーザーが削除されました。"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :github_uid, :github_token, :profile_picture)
  end
end
