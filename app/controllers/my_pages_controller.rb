class MyPagesController < ApplicationController
  before_action :require_login

  def show
    @user = current_user

    # ✨ クリアフラグがあれば return_to セッションを消す
    session.delete(:mypage_return_to) if params[:clear_return_to].present?

    # 初回のみセッションに保存
    if params[:return_to].present? && URI.parse(params[:return_to]).host.nil?
      session[:mypage_return_to] = params[:return_to] if params[:return_to].present? && URI.parse(params[:return_to]).host.nil?
    end

    @safe_return_to = session[:mypage_return_to]
  rescue URI::InvalidURIError
    @safe_return_to = nil
  end

  private

  def require_login
    redirect_to root_path, alert: "ログインが必要です" unless current_user
  end
end
