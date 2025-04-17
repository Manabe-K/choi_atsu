class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]
  before_action :require_login

  def index
    @events = current_user.demo? ? Event.demo_visible_to(current_user) : Event.exclude_demo_users

    if params[:tag].present?
      @events = @events.joins(:tags).where(tags: { name: params[:tag] })
    end

    @events = @events.includes(:host_user, :participant_users).distinct
    @tags = Tag.all
  end

  def show; end

  def new
    @event = Event.new
  end

  def edit; end

  def create
    @event = Event.new(parsed_event_params)
    @event.host_user = current_user

    if @event.save
      Participant.create!(user: current_user, event: @event)
      update_participants(@event)
      redirect_to @event, notice: "イベントを作成しました"
    else
      # 🚨 エラー時に選択中ユーザーを復元
      user_ids = params[:event][:user_ids].to_a.reject(&:blank?)
      @selected_users = User.where(id: user_ids)
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(parsed_event_params)
      update_participants(@event)
      redirect_to @event, notice: "イベントを更新しました"
    else
      # 🚨 エラー時に選択中ユーザーを復元
      user_ids = params[:event][:user_ids].to_a.reject(&:blank?)
      @selected_users = User.where(id: user_ids)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, notice: "イベントを削除しました", status: :see_other
  end

  def participating
    @hosted_events = current_user.hosted_events
    @joined_events = current_user.joined_events.where.not(id: @hosted_events.pluck(:id))
    render :participating
  end

  def interested
    @events = current_user.curious_events.includes(:host_user)
    render :interested
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def parsed_event_params
    raw = event_params
    raw[:start_time] = parse_datetime(raw[:start_time])
    raw[:end_time]   = parse_datetime(raw[:end_time])
    raw[:deadline]   = parse_datetime(raw[:deadline])
    raw
  end

  def parse_datetime(str)
    return nil if str.blank?
    DateTime.strptime(str, "%m月%d日 %H:%M") rescue nil
  end

  def event_params
    params.require(:event).permit(
      :title,
      :start_time,
      :end_time,
      :deadline,
      :location,
      :description,
      :capacity,
    )
  end

  def require_login
    redirect_to root_path, alert: "ログインが必要です" unless current_user
  end

  def update_participants(event)
    user_ids = params[:event][:user_ids].to_a.reject(&:blank?).map(&:to_i)
    user_ids -= [ event.host_user_id ]  # 主催者は除外

    current_ids = event.participant_users.where.not(id: event.host_user_id).pluck(:id)

    to_remove = current_ids - user_ids
    to_add = user_ids - current_ids

    if (event.participant_users.count - to_remove.size + to_add.size + 1) > event.capacity.to_i
      flash[:alert] = "参加者数が上限を超えています"
      return false
    end

    event.participants.where(user_id: to_remove).destroy_all
    to_add.each { |uid| event.participants.find_or_create_by(user_id: uid) }

    true
  end
end
