# app/models/thread_post.rb
class ThreadPost < ApplicationRecord
  belongs_to :event
  belongs_to :user

  validates :content, presence: true
  validates :content, format: { without: /\A\s*\z/, message: "を入力してください" }
end