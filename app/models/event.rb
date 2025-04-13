class Event < ApplicationRecord
  belongs_to :host_user, class_name: "User"
  has_many :event_tags, dependent: :destroy
  has_many :tags, through: :event_tags

  scope :for_user, ->(user) {
    if user.demo?
      where(user_id: user.id) # デモユーザーは自分のだけ
    else
      where(demo: false) # 本番ユーザーはデモ用でないデータ
    end
  }
end
