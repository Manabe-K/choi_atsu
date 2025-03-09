# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Event.create!(
  title: "サンプルイベント1",
  start_time: "2025-03-10 10:00:00",
  end_time: "2025-03-10 12:00:00",
  deadline: "2025-03-09 23:59:59",
  location: "イベント会場1",
  description: "これはテスト用のイベントです。",
  capacity: 50,
  host_user_id: 1  # 仮のユーザーIDを指定（例えば、1）
)

Event.create!(
  title: "サンプルイベント2",
  start_time: "2025-03-15 14:00:00",
  end_time: "2025-03-15 16:00:00",
  deadline: "2025-03-14 23:59:59",
  location: "イベント会場2",
  description: "これは別のテスト用イベントです。",
  capacity: 30,
  host_user_id: 2  # 仮のユーザーIDを指定（例えば、2）
)