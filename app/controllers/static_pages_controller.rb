class StaticPagesController < ApplicationController
  before_action :redirect_if_logged_in, only: :top

  def top
    # ログイン前のトップページ（公開用）
  end

  private

  def redirect_if_logged_in
    if current_user
      redirect_to events_path, notice: "すでにログインしています。"
    end
  end
end
