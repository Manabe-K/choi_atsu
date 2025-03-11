class User < ApplicationRecord
  has_many :hosted_events, class_name: "Event", foreign_key: "host_user_id"
end
