class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user  # viewでもcurrent_userが使えるようにする

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def after_sign_in_path_for(resource_or_scope)
    events_path  # ログイン後にリダイレクトするパス
  end
end
