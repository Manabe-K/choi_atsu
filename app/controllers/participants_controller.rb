class ParticipantsController < ApplicationController
  before_action :require_login

  def create
    event = Event.find(params[:event_id])

    if event.participant_users.exists?(current_user.id)
      redirect_to event_path(event), alert: "すでに参加済みです"
    else
      Participant.create!(user: current_user, event: event)
      redirect_to event_path(event), notice: "イベントに参加しました！"
    end
  end

  def destroy
    event = Event.find(params[:event_id])
    participant = Participant.find_by(user: current_user, event: event)

    if participant
      participant.destroy
      redirect_to event_path(event), notice: "参加をキャンセルしました"
    else
      redirect_to event_path(event), alert: "参加情報が見つかりません"
    end
  end

  private

  def require_login
    redirect_to root_path, alert: "ログインが必要です" unless current_user
  end
end
