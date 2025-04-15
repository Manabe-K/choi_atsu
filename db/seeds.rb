puts "🌱 デモユーザーとイベントデータを生成します"

nicknames = %w[たろう ちくわ チャット君 エンジニア猫 フクロウ先生]

# デモユーザー5人を作成または確認
demo_users = (1..5).map do |i|
  github_uid = "demo_seed_user#{i}"
  user = User.find_by(github_uid: github_uid)

  if user
    puts "⚠️ #{github_uid}（#{user.name}）は既に存在します"
    user
  else
    user = User.create!(
      github_uid: github_uid,
      name: nicknames[i % nicknames.size],
      github_token: "dummy_token_#{i}",
      profile_picture: "demo_image_#{i}.png"
    )
    puts "✅ #{github_uid}（#{user.name}）を作成しました"
    user
  end
end

# タグ作成（すでにある場合はスキップ）
puts "🏷️ タグを作成・確認します"

(1..10).each do |i|
  tag_name = "タグ#{i}"
  tag = Tag.find_by(name: tag_name)

  if tag
    puts "⚠️ #{tag_name} は既に存在します"
  else
    Tag.create!(name: tag_name)
    puts "✅ #{tag_name} を作成しました"
  end
end

sample_tags = Tag.pluck(:id)

# イベントタイプ定義
event_types = %w[
  available
  full
  closed
  full_and_closed
  almost_full
  past
]

# イベント作成判定（既に作成済みならスキップしたい場合はここで判定）
existing_event_count = Event.joins(:host_user).where("users.github_uid LIKE ?", "demo_seed_user%").count

if existing_event_count > 0
  puts "⚠️ すでにデモイベントが存在するため、作成をスキップしました（#{existing_event_count}件）"
else
  puts "🛠️ デモイベントを作成します"

  created_events = []

  # 各タイプを最低2件ずつ作成（12件）
  event_types.each do |type|
    2.times { created_events << type }
  end

  # 残り8件はランダムで補充して20件にする
  remaining = 20 - created_events.size
  created_events += Array.new(remaining) { event_types.sample }

  created_events.each_with_index do |type, i|
    host = demo_users.sample

    case type
    when "available"
      start_time = Time.current + rand(1..5).days
      end_time = start_time + rand(1..3).hours
      deadline = start_time - 1.day
      capacity = rand(5..10)
      participants = rand(0..(capacity - 1))

    when "full"
      start_time = Time.current + rand(1..5).days
      end_time = start_time + rand(1..3).hours
      deadline = start_time - 1.day
      capacity = rand(3..6)
      participants = capacity

    when "closed"
      start_time = Time.current + rand(2..5).days
      end_time = start_time + rand(1..3).hours
      deadline = Time.current - rand(1..2).days
      capacity = rand(5..10)
      participants = rand(0..(capacity - 1))

    when "full_and_closed"
      start_time = Time.current + rand(2..5).days
      end_time = start_time + rand(1..3).hours
      deadline = Time.current - 1.day
      capacity = rand(3..6)
      participants = capacity

    when "almost_full"
      start_time = Time.current + rand(2..5).days
      end_time = start_time + rand(1..3).hours
      deadline = start_time - 1.day
      capacity = rand(2..5)
      participants = capacity - 1

    when "past"
      start_time = Time.current - rand(2..10).days
      end_time = start_time + rand(1..3).hours
      deadline = start_time - 1.day
      capacity = rand(5..10)
      participants = rand(0..capacity)
    end

    event = Event.create!(
      title: "デモイベント#{i + 1}:#{['交流会', 'もくもく会', '雑談'].sample}",
      start_time: start_time,
      end_time: end_time,
      deadline: deadline,
      location: %w[オンライン 渋谷 大阪 福岡 名古屋].sample,
      description: "これはランダム生成された#{type}イベントです。",
      capacity: capacity,
      host_user: host
    )

    event.tag_ids = sample_tags.sample(rand(1..3))

    participants_users = demo_users.reject { |u| u == host }.sample(participants)
    participants_users.each do |user|
      Participant.find_or_create_by!(event: event, user: user)
    end

    puts "✅ イベント#{i + 1}（#{type}）を作成しました"
  end

  puts "🎉 合計 #{created_events.size}件のデモイベントが作成されました"
end