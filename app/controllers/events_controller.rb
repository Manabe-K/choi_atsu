class EventsController < ApplicationController
  include EventsHelper

  before_action :set_event, only: %i[show edit update destroy]
  before_action :require_login

  def index
    base = Event.for_user(current_user)

    if params[:tag].present?
      @current_tag = Tag.find_by(name: params[:tag])
      base = base.joins(:tags).where(tags: { name: @current_tag.name }) if @current_tag
    end

    if params[:interested] == "1"
      base =
        if current_user.tags.any?
          base.joins(:tags).where(tags: { id: current_user.tags.ids }).distinct
        else
          base.none
        end
    end

    if params[:available] == "1"
      base = base.where("deadline IS NULL OR deadline >= ?", Time.current)
    end

    base = base.includes(:host_user, :participant_users)
    all_events = base.to_a

    if params[:available] == "1"
      all_events = all_events.reject { |e| event_full?(e) || e.host_user_id == current_user.id }
    end

    sorted = sort_with_upcoming_last(all_events)
    @events = Kaminari.paginate_array(sorted).page(params[:page])
    @tags = Tag.all
  end

  def participating
    hosted = current_user.hosted_events
    joined = current_user.joined_events.where.not(id: hosted.pluck(:id))

    @hosted_events = Kaminari.paginate_array(sort_with_upcoming_last(hosted)).page(params[:hosted_page])
    @joined_events = Kaminari.paginate_array(sort_with_upcoming_last(joined)).page(params[:joined_page])
  end

  def interested
    events = current_user.curious_events.includes(:host_user)
    sorted = sort_with_upcoming_last(events)
    @events = Kaminari.paginate_array(sorted).page(params[:page])
  end

  def show; end
  def new; @event = Event.new; end
  def edit; end

  def create
    @event = Event.new(parsed_event_params)
    @event.host_user = current_user
  
    if valid_tag_names?(params[:event][:tag_names]) && @event.save
      update_event_tags(@event, params[:event][:tag_names])
      Participant.create!(user: current_user, event: @event)
      update_participants(@event)
      redirect_to @event, notice: "イベントを作成しました"
    else
      @event.errors.add(:base, "登録済みのタグのみ使用できます") unless valid_tag_names?(params[:event][:tag_names])
      @selected_users = load_selected_users
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(parsed_event_params)
      update_event_tags(@event, params[:event][:tag_names])
      update_participants(@event)
      redirect_to @event, notice: "イベントを更新しました"
    else
      @selected_users = load_selected_users
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
    params.require(:event).permit(:title, :start_time, :end_time, :deadline, :location, :description, :capacity)
  end

  def parsed_event_params
    raw = event_params.to_h
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
    user_ids = params[:event][:user_ids].to_a.map(&:to_i).reject(&:zero?)
    user_ids -= [ event.host_user_id ]

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

  def update_event_tags(event, tag_names_param)
    tag_names = Array(tag_names_param).reject(&:blank?).map(&:strip).uniq
  
    current_tags = event.tags.pluck(:name)
    to_remove = current_tags - tag_names
    to_add    = tag_names - current_tags
  
    # タグ削除
    event.event_tags.joins(:tag).where(tags: { name: to_remove }).destroy_all
  
    # タグ追加（既存タグのみ使用）
    valid_tags = Tag.where(name: to_add)
    valid_tags.each do |tag|
      event.event_tags.find_or_create_by(tag: tag)
    end
  end

  def sort_with_upcoming_last(events)
    now = Time.current

    sort_key =
      case params[:sort]
      when "start_asc", "start_desc" then :start_time
      when "deadline_asc"           then :deadline
      when "created_desc"           then :created_at
      else                                 :start_time
      end

    sort_attr = sort_key.to_s
    descending = params[:sort]&.include?("desc")

    upcoming = events.select { |e| e.end_time && e.end_time >= now }
                     .sort_by { |e| e.attributes[sort_attr] || Time.at(0) }
    upcoming.reverse! if descending

    past = events.reject { |e| e.end_time && e.end_time >= now }
                 .sort_by { |e| e.attributes[sort_attr] || Time.at(0) }
    past.reverse! if descending

    upcoming + past
  end

  def load_selected_users
    ids = params[:event][:user_ids].to_a.map(&:to_i).reject(&:zero?)
    User.where(id: ids)
  end

  def valid_tag_names?(tag_names_param)
    tag_names = Array(tag_names_param).reject(&:blank?).map(&:strip).uniq
    Tag.where(name: tag_names).count == tag_names.count
  end
end