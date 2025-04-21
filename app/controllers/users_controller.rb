class UsersController < ApplicationController
  include Rails.application.routes.url_helpers

  before_action :set_user, only: %i[show destroy]
  before_action :require_login, only: %i[edit update destroy]

  def show; end

  def new
    unless session[:user_registration]
      redirect_to root_path, alert: "不正なアクセスです。" and return
    end

    @user = User.new(session[:user_registration])
  end

  def create
    @user = User.new(user_params_for_create)

    if @user.save
      session.delete(:user_registration)
      session[:user_id] = @user.id
      redirect_to events_path(interested: 1, available: 1), notice: "ユーザー登録が完了しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    # アップロード画像の削除処理
    if params[:user][:remove_uploaded_picture] == "true"
      @user.uploaded_picture.purge if @user.uploaded_picture.attached?
    end

    if @user.update(user_params_for_update)
      update_user_tags(@user, params[:user][:tag_names])
      redirect_to mypage_path, notice: "ユーザー情報が更新されました。"
    else
      render :edit, status: :unprocessable_entity
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
    users = current_user.github_uid&.start_with?("demo_") ? users.where("github_uid LIKE ?", "demo_%") : users.where.not("github_uid LIKE ?", "demo_%")
    users = users.where.not(id: current_user.id).limit(10)

    results = users.map do |user|
      {
        id: user.id,
        name: user.name,
        profile_picture: user.profile_picture_url
      }
    end

    render json: results
  end

  def delete_uploaded_picture
    user = User.find(params[:id])

    if user == current_user && user.uploaded_picture.attached?
      user.uploaded_picture.purge
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to edit_user_path(user), notice: "アップロード画像を削除しました" }
      end
    else
      respond_to do |format|
        format.turbo_stream { head :not_found }
        format.html { redirect_to edit_user_path(user), alert: "画像が見つかりません" }
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def require_login
    redirect_to root_path, alert: "ログインしてください。" unless current_user
  end

  def user_params_for_create
    params.require(:user).permit(:name, :github_uid, :github_token, :profile_picture, :uploaded_picture)
  end

  def user_params_for_update
    params.require(:user).permit(:name, :github_uid, :github_token, :profile_picture, :uploaded_picture)
  end

  def update_user_tags(user, tag_names_param)
    tag_names = Array(tag_names_param).reject(&:blank?).map(&:strip).uniq

    current_tags = user.tags.pluck(:name)
    to_remove = current_tags - tag_names
    to_add    = tag_names - current_tags

    user.user_tags.joins(:tag).where(tags: { name: to_remove }).destroy_all

    to_add.each do |name|
      tag = Tag.find_or_create_by(name: name)
      user.user_tags.find_or_create_by(tag: tag)
    end
  end
end
