class ThreadPostsChannel < ApplicationCable::Channel
  def subscribed
    event_id = params[:event_id] # イベントIDを受け取る
    stream_for "event_#{event_id}_thread_posts"
  end
end