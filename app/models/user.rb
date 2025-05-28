class User < ApplicationRecord
  has_one_attached :uploaded_picture
  has_many :hosted_events, class_name: "Event", foreign_key: :host_user_id, dependent: :destroy

  has_many :participants, dependent: :destroy
  has_many :joined_events, through: :participants, source: :event

  has_many :curious_lists, dependent: :destroy
  has_many :curious_events, through: :curious_lists, source: :event

  has_many :user_tags, dependent: :destroy
  has_many :tags, through: :user_tags

  has_many :thread_posts, dependent: :destroy

  validates :github_uid, presence: true, uniqueness: true
  validates :name, :profile_picture, presence: true

  # Methods
  def demo?
    github_uid&.start_with?("demo_")
  end

  def profile_picture_url
    if uploaded_picture.attached?
      Rails.application.routes.url_helpers.rails_blob_url(uploaded_picture, only_path: true)
    elsif profile_picture&.start_with?("http")
      profile_picture
    elsif profile_picture&.start_with?("demo_image_")
      ActionController::Base.helpers.image_path("demo_images/#{profile_picture}")
    else
      ActionController::Base.helpers.image_path("demo_images/default.png")
    end
  end
end
