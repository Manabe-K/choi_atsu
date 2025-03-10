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

Event.create!(
  title: "サンプルイベント3",
  start_time: "2025-03-20 09:00:00",
  end_time: "2025-03-20 11:00:00",
  deadline: "2025-03-19 23:59:59",
  location: "イベント会場3",
  description: "テストイベントその3です。",
  capacity: 40,
  host_user_id: 3
)

Event.create!(
  title: "サンプルイベント4",
  start_time: "2025-03-25 13:00:00",
  end_time: "2025-03-25 15:00:00",
  deadline: "2025-03-24 23:59:59",
  location: "イベント会場4",
  description: "サンプルイベント4です。",
  capacity: 20,
  host_user_id: 4
)

Event.create!(
  title: "サンプルイベント5",
  start_time: "2025-03-30 10:00:00",
  end_time: "2025-03-30 12:00:00",
  deadline: "2025-03-29 23:59:59",
  location: "イベント会場5",
  description: "イベント5の説明です。",
  capacity: 50,
  host_user_id: 5
)

Event.create!(
  title: "サンプルイベント6",
  start_time: "2025-04-05 14:00:00",
  end_time: "2025-04-05 16:00:00",
  deadline: "2025-04-04 23:59:59",
  location: "イベント会場6",
  description: "イベント6のテスト。",
  capacity: 100,
  host_user_id: 6
)

Event.create!(
  title: "サンプルイベント7",
  start_time: "2025-04-10 18:00:00",
  end_time: "2025-04-10 20:00:00",
  deadline: "2025-04-09 23:59:59",
  location: "イベント会場7",
  description: "サンプルイベント7。",
  capacity: 75,
  host_user_id: 7
)

Event.create!(
  title: "サンプルイベント8",
  start_time: "2025-04-15 09:00:00",
  end_time: "2025-04-15 11:00:00",
  deadline: "2025-04-14 23:59:59",
  location: "イベント会場8",
  description: "テストイベント8。",
  capacity: 60,
  host_user_id: 8
)

Event.create!(
  title: "サンプルイベント9",
  start_time: "2025-04-20 11:00:00",
  end_time: "2025-04-20 13:00:00",
  deadline: "2025-04-19 23:59:59",
  location: "イベント会場9",
  description: "サンプルイベント9。",
  capacity: 80,
  host_user_id: 9
)

Event.create!(
  title: "サンプルイベント10",
  start_time: "2025-04-25 12:00:00",
  end_time: "2025-04-25 14:00:00",
  deadline: "2025-04-24 23:59:59",
  location: "イベント会場10",
  description: "テストイベント10です。",
  capacity: 150,
  host_user_id: 10
)
