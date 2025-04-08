class User < ApplicationRecord
  has_many :hosted_events, class_name: "Event", foreign_key: "host_user_id"
  validates :github_uid, presence: true, uniqueness: true
  validates :name, presence: true
  validates :profile_picture, presence: true

  # GitHub認証後のコールバック処理
  def self.from_omniauth(auth)
    user = User.where(github_uid: auth.uid).first_or_initialize
    user.name = auth.info.name
    user.profile_picture = auth.info.image
    user.github_token = auth.credentials.token
    user.save
    user
  end
end
