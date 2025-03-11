# 現在のデータを削除
Event.delete_all
Tag.delete_all
User.delete_all

# ユーザーの作成
users = User.create!(
  10.times.map do |i|
    {
      name: "ユーザー#{i + 1}",
      uid: "uid#{i + 1}"
    }
  end
)

# タグの作成
tags = Tag.create!(
  10.times.map do |i|
    { name: "タグ#{i + 1}" }
  end
)

# イベントの作成
events = Event.create!(
  10.times.map do |i|
    {
      title: "サンプルイベント#{i + 1}",
      start_time: "2025-03-10 10:00:00".to_time + (i * 5).days,
      end_time: "2025-03-10 12:00:00".to_time + (i * 5).days,
      deadline: "2025-03-09 23:59:59".to_time + (i * 5).days,
      location: "イベント会場#{i + 1}",
      description: "テスト用のイベント#{i + 1}です。",
      capacity: [30, 50, 75, 100, 150].sample,
      host_user_id: users[i].id
    }
  end
)

# イベントにタグをランダムに関連付け
events.each do |event|
  # それぞれのイベントにランダムに1〜3個のタグを関連付け
  event.tags = tags.sample(rand(1..3))
end

puts "データが作成されました！"