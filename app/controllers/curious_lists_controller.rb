class CuriousListsController < ApplicationController
  before_action :require_login

  def create
    event = Event.find(params[:event_id])
    CuriousList.find_or_create_by(user: current_user, event: event)
    redirect_back fallback_location: events_path, notice: "気になるに追加しました"
  end

  def destroy
    event = Event.find(params[:event_id])
    curious = CuriousList.find_by(user: current_user, event: event)
    curious&.destroy
    redirect_back fallback_location: events_path, notice: "気になるを解除しました"
  end

  private

  def require_login
    redirect_to root_path, alert: "ログインが必要です" unless current_user
  end
end
