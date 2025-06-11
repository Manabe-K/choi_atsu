class ThreadPostsChannel < ApplicationCable::Channel
  include Turbo::Streams::ActionHelper

  def subscribed
    event = Event.find(params[:event_id])
    stream_for event
  end
end