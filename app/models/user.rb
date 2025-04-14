class User < ApplicationRecord
  has_many :hosted_events, class_name: "Event", foreign_key: "host_user_id", dependent: :destroy
  has_many :participants
  has_many :joined_events, through: :participants, source: :event
  has_many :curious_lists
  has_many :curious_events, through: :curious_lists, source: :event
  validates :github_uid, presence: true, uniqueness: true
  validates :name, presence: true
  validates :profile_picture, presence: true

  def demo?
    github_uid&.start_with?("demo_")
  end
end
