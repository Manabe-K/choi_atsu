class UsersController < ApplicationController
  before_action :set_user, only: %i[show destroy]
  before_action :require_login, only: %i[edit update destroy]

  # 管理者以外はアクセス不可（今はコメントアウト）
  # def index
  #   @users = User.all
  # end

  def show;end

  def new
    redirect_to root_path, alert: "不正なアクセスです。" and return unless session[:user_registration]
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
    @user = current_user
  end

  def update
    if current_user.update(user_params)
      redirect_to current_user, notice: "ユーザー情報が更新されました。"
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    reset_session if current_user == @user
    redirect_to root_path, notice: "ユーザーが削除されました。"
  end

  def search
    query = params[:q].to_s.strip
    return render json: [] if query.blank?

    users = User.where("name ILIKE ?", "%#{query}%")

    # 検索したのが demo ユーザーなら、通常ユーザーを除外
    if current_user.github_uid&.start_with?("demo_")
      users = users.where("github_uid LIKE ?", "demo_%")
    else
      # 検索したのが通常ユーザーなら、demoユーザーを除外
      users = users.where.not("github_uid LIKE ?", "demo_%")
    end

    users = users.where.not(id: current_user.id).limit(10)

    results = users.map do |user|
    {
    id: user.id,
    name: user.name,
    profile_picture: user.profile_picture.present? ? helpers.asset_url(user.profile_picture) : nil
    }
end

render json: results
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def require_login
    redirect_to root_path, alert: "ログインしてください。" unless current_user
  end

  def user_params
    params.require(:user).permit(:name, :github_uid, :github_token, :profile_picture)
  end
end
