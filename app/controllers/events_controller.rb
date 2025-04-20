class EventsController < ApplicationController
  include EventsHelper

  before_action :set_event, only: %i[ show edit update destroy ]
  before_action :require_login

  def index
    base = Event.for_user(current_user)
  
    if params[:tag].present?
      @current_tag = Tag.find_by(name: params[:tag])
      base = base.joins(:tags).where(tags: { name: @current_tag.name }) if @current_tag
    end
  
    if params[:interested] == "1"
      if current_user.tags.any?
        base = base.joins(:tags).where(tags: { id: current_user.tags.ids }).distinct
      else
        base = base.none
      end
    end
  
    if params[:available] == "1"
      base = base.where("deadline IS NULL OR deadline >= ?", Time.current)
    end
  
    base = base.includes(:host_user, :participant_users)
    puts "🔍 イベント一覧: #{base.size}件（フィルタ前）"
base.each do |event|
  puts "📝 イベントID: #{event.id}, 主催者: #{event.host_user.name}, UID: #{event.host_user.github_uid}"
end
    events = base.to_a
  
    if params[:available] == "1"
      events = events.reject { |e| event_full?(e) || e.host_user_id == current_user.id }
    end
  
    @events = sort_with_upcoming_last(events)
    @tags = Tag.all
  end

  def participating
    hosted = current_user.hosted_events
    joined = current_user.joined_events.where.not(id: hosted.pluck(:id))

    @hosted_events = sort_with_upcoming_last(hosted)
    @joined_events = sort_with_upcoming_last(joined)
  end

  def interested
    @events = sort_with_upcoming_last(current_user.curious_events.includes(:host_user))
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
      user_ids = params[:event][:user_ids].to_a.reject(&:blank?)
      @selected_users = User.where(id: user_ids)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path(interested: 1, available: 1), notice: "イベントを削除しました", status: :see_other
  end

  def curious_users
    @event = Event.find(params[:id])
    @users = @event.curious_users.includes(:tags)
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(
      :title, :start_time, :end_time, :deadline, :location, :description, :capacity
    )
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

  def require_login
    redirect_to root_path, alert: "ログインが必要です" unless current_user
  end

  def update_participants(event)
    user_ids = params[:event][:user_ids].to_a.reject(&:blank?).map(&:to_i)
    user_ids -= [event.host_user_id]

    current_ids = event.participant_users.where.not(id: event.host_user_id).pluck(:id)

    to_remove = current_ids - user_ids
    to_add = user_ids - current_ids

    capacity = event.capacity.to_i
    capacity = 999 if capacity.zero?

    if (event.participant_users.count - to_remove.size + to_add.size + 1) > capacity
      flash[:alert] = "参加者数が上限を超えています"
      return false
    end

    event.participants.where(user_id: to_remove).destroy_all
    to_add.each { |uid| event.participants.find_or_create_by(user_id: uid) }

    true
  end

  def sort_with_upcoming_last(events)
    now = Time.current

    sort_order =
      case params[:sort]
      when "start_asc"     then { start_time: :asc }
      when "start_desc"    then { start_time: :desc }
      when "deadline_asc"  then { deadline: :asc }
      when "created_desc"  then { created_at: :desc }
      else                      { start_time: :asc }
      end

    upcoming = events.select { |e| e.end_time >= now }
                     .sort_by { |e| e.attributes.slice(*sort_order.keys.map(&:to_s)).values }

    past = events.select { |e| e.end_time < now }
                 .sort_by { |e| e.attributes.slice(*sort_order.keys.map(&:to_s)).values }

    upcoming + past
  end
end