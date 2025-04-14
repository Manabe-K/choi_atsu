class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]
  before_action :require_login

  def index
    @events = current_user.demo? ? Event.demo_visible_to(current_user) : Event.exclude_demo_users

    if params[:tag].present?
      @events = @events.joins(:tags).where(tags: { name: params[:tag] })
    end

    @events = @events.includes(:host_user).distinct
    @tags = Tag.all
  end

  def show; end

  def new
    @event = Event.new
  end

  def edit; end

  def create
    @event = Event.new(event_params)
    @event.host_user = current_user

    if @event.save
      redirect_to @event, notice: "イベントを作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: "イベントを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, notice: "イベントを削除しました", status: :see_other
  end

private
  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :start_time, :end_time, :deadline, :location, :description, :capacity)
  end

  def require_login
    unless current_user
      redirect_to root_path, alert: "ログインが必要です"
    end
  end
end
