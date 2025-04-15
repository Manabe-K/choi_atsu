class Event < ApplicationRecord
  belongs_to :host_user, class_name: "User"
  has_many :event_tags, dependent: :destroy
  has_many :tags, through: :event_tags
  has_many :participants, dependent: :destroy
  has_many :participant_users, through: :participants, source: :user
  has_many :curious_lists, dependent: :destroy
  has_many :curious_users, through: :curious_lists, source: :user

  scope :exclude_demo_users, -> {
    joins(:host_user).where.not("users.github_uid LIKE ?", "demo_seed_user%")
  }

  scope :demo_visible_to, ->(user) {
    joins(:host_user).where(
      "users.github_uid LIKE ? OR events.host_user_id = ?", "demo_seed_user%", user.id
    )
  }

  scope :for_user, ->(user) {
    user.demo? ? demo_visible_to(user) : exclude_demo_users
  }
end
