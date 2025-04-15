class ParticipantsController < ApplicationController
  before_action :require_login

  def create
    @event = Event.find(params[:event_id])

    if @event.participant_users.exists?(current_user.id)
      respond_to do |format|
        format.turbo_stream { head :conflict }
        format.html { redirect_to events_path, alert: "すでに参加済みです" }
      end
    else
      Participant.create!(user: current_user, event: @event)

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to events_path, notice: "イベントに参加しました！" }
      end
    end
  end

  def destroy
    @event = Event.find(params[:event_id])
    participant = Participant.find_by(user: current_user, event: @event)

    if participant
      participant.destroy

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to events_path, notice: "参加をキャンセルしました" }
      end
    else
      respond_to do |format|
        format.turbo_stream { head :not_found }
        format.html { redirect_to events_path, alert: "参加情報が見つかりません" }
      end
    end
  end

  private

  def require_login
    redirect_to root_path, alert: "ログインが必要です" unless current_user
  end
end
