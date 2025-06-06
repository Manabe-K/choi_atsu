# app/models/thread_post.rb
class ThreadPost < ApplicationRecord
  belongs_to :event
  belongs_to :user

  validates :content, presence: true
  validates :content, format: { without: /\A\s*\z/, message: "を入力してください" }

  after_create_commit do
    ThreadPostsChannel.broadcast_append_to(
      event,
      target: "thread_posts",
      partial: "thread_posts/thread_post",
      locals: { thread_post: self, event: event }
    )
  end

  after_destroy_commit do
    ThreadPostsChannel.broadcast_remove_to(
      event,
      target: dom_id(self)
    )
  end
end
