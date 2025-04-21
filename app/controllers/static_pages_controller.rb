class StaticPagesController < ApplicationController
  before_action :redirect_if_logged_in, only: :top

  def top
    # ログイン前のトップページ（公開用）
  end

  private

  def redirect_if_logged_in
    return unless current_user
    redirect_to events_path(interested: 1, available: 1), notice: "すでにログインしています。"
  end
end
