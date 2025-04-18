class User < ApplicationRecord
  has_many :hosted_events, class_name: "Event", foreign_key: :host_user_id, dependent: :destroy

  has_many :participants, dependent: :destroy
  has_many :joined_events, through: :participants, source: :event

  has_many :curious_lists, dependent: :destroy
  has_many :curious_events, through: :curious_lists, source: :event

  has_many :user_tags, dependent: :destroy
  has_many :tags, through: :user_tags

  validates :github_uid, presence: true, uniqueness: true
  validates :name, :profile_picture, presence: true

  # Methods
  def demo?
    github_uid&.start_with?("demo_")
  end
end
