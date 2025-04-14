class User < ApplicationRecord
  has_many :hosted_events, class_name: "Event", foreign_key: "host_user_id", dependent: :destroy
  validates :github_uid, presence: true, uniqueness: true
  validates :name, presence: true
  validates :profile_picture, presence: true

  def demo?
    github_uid&.start_with?("demo_")
  end
end
