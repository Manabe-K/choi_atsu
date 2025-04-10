class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = session[:user_registration] ? User.new(session[:user_registration]) : User.new
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
