class UserTagsController < ApplicationController
  before_action :require_login

  def create
    tag = Tag.find_or_create_by(name: params[:name].strip)

    user_tag = current_user.user_tags.find_or_initialize_by(tag: tag)
    user_tag.notify_enabled = true

    if user_tag.save
      redirect_back fallback_location: root_path, notice: "タグを登録しました。"
    else
      redirect_back fallback_location: root_path, alert: "タグの登録に失敗しました。"
    end
  end

  def destroy
    user_tag = current_user.user_tags.find_by(tag_id: params[:tag_id])

    if user_tag&.destroy
      redirect_back fallback_location: root_path, notice: "タグを削除しました。"
    else
      redirect_back fallback_location: root_path, alert: "タグの削除に失敗しました。"
    end
  end
end
