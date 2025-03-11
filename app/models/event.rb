class Event < ApplicationRecord
  belongs_to :host_user, class_name: "User"

  has_many :event_tags, dependent: :destroy
  has_many :tags, through: :event_tags
end
