class TagsController < ApplicationController
  before_action :set_tag, only: %i[update destroy ]
  before_action :require_login

  def create
    @tag = Tag.new(tag_params)

    respond_to do |format|
      if @tag.save
        format.html { redirect_to @tag }
        format.json { render :show, status: :created, location: @tag }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to @tag }
        format.json { render :show, status: :ok, location: @tag }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @tag.destroy!

    respond_to do |format|
      format.html { redirect_to tags_path, status: :see_other }
      format.json { head :no_content }
    end
  end

  def users
    @tag = Tag.find(params[:id])
    @users = @tag.users.includes(:tags)
  end

  def search
    query = params[:q].to_s.strip
    return render json: [] if query.blank?

    tags = Tag
             .left_joins(:user_tags) # ← user_tags 経由でユーザー数をカウント！
             .where("tags.name ILIKE ?", "%#{query}%")
             .group("tags.id")
             .select("tags.name, COUNT(user_tags.id) AS user_count")
             .order("tags.name")
             .limit(10)

    results = tags.map do |tag|
      {
        name: tag.name,
        user_count: tag.user_count.to_i
      }
    end

    render json: results
  end

  private

    def set_tag
      @tag = Tag.find(params[:id])
    end

    def tag_params
      params.require(:tag).permit(:name)
    end

    def require_login
      unless current_user
        redirect_to root_path, alert: "ログインが必要です"
      end
    end
end
