class ThreadPostsController < ApplicationController
  before_action :require_login
  before_action :set_event
  before_action :set_thread_post, only: [ :edit, :update, :destroy, :show ]

  def show
    @event = Event.find(params[:event_id])
    @thread_post = @event.thread_posts.find(params[:id])

    respond_to do |format|
      format.turbo_stream
      format.html { head :not_acceptable }
    end
  end

  def create
    @thread_post = @event.thread_posts.new(thread_post_params)
    @thread_post.user = current_user

    if @thread_post.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @event, notice: "投稿しました" }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("new_thread_post", partial: "thread_posts/form", locals: { thread_post: @thread_post, event: @event }) }
        format.html { redirect_to @event, alert: "投稿に失敗しました" }
      end
    end
  end

  def edit
    respond_to do |format|
      format.turbo_stream
      format.html { head :not_acceptable }
    end
  end

  def update
    if @thread_post.update(thread_post_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @event, notice: "投稿を更新しました" }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @thread_post.destroy if @thread_post.user == current_user

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @event, notice: "投稿を削除しました" }
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_thread_post
    @thread_post = @event.thread_posts.find(params[:id])
  end

  def thread_post_params
    params.require(:thread_post).permit(:content)
  end
end
