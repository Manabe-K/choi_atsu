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

# タグ作成
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
event_types = %w[available full closed full_and_closed almost_full past]

# 作成済み判定
existing_event_count = Event.joins(:host_user).where("users.github_uid LIKE ?", "demo_seed_user%").count

if existing_event_count > 0
  puts "⚠️ すでにデモイベントが存在するため、作成をスキップしました（#{existing_event_count}件）"
else
  puts "🛠️ デモイベントを作成します"
  created_events = []

  event_types.each { |type| 2.times { created_events << type } }
  created_events += Array.new(20 - created_events.size) { event_types.sample }

  created_events.each_with_index do |type, i|
    host = demo_users.sample

    # イベント基本情報
    start_time, end_time, deadline = nil
    case type
    when "available", "full", "closed", "full_and_closed", "almost_full"
      start_time = Time.current + rand(1..5).days
      end_time = start_time + rand(1..3).hours
    when "past"
      start_time = Time.current - rand(2..10).days
      end_time = start_time + rand(1..3).hours
    end

    deadline =
      case type
      when "closed", "full_and_closed"
        Time.current - 1.day
      when "past"
        start_time - 1.day
      else
        start_time - 1.day
      end

    capacity =
      case type
      when "full", "full_and_closed"
        rand(3..6)
      when "almost_full"
        rand(2..5)
      else
        rand(5..10)
      end

    # イベント作成
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

    # ✅ 主催者を参加者として登録
    Participant.create!(event: event, user: host)

    # 残りの参加者を登録
    participants_to_register =
      case type
      when "full", "full_and_closed"
        capacity - 1
      when "almost_full"
        [capacity - 2, 0].max
      when "available"
        rand(0..[capacity - 3, 0].max)
      when "closed", "past"
        rand(0..[capacity - 1, 0].max)
      end

    selected_users = demo_users.reject { |u| u == host }.sample(participants_to_register)
    registered_count = 1 # ← 主催者1名を含む

    selected_users.each do |user|
      begin
        Participant.create!(event: event, user: user)
        registered_count += 1
      rescue ActiveRecord::RecordInvalid => e
        puts "⚠️ 参加登録失敗: #{user.name} → #{e.message}"
      end
    end

    # 表示用
    status_label =
      if registered_count == capacity
        "満席"
      elsif registered_count == capacity - 1
        "あと1名"
      else
        "余裕あり"
      end

    puts "✅ イベント#{i + 1}（#{type}）作成：参加者#{registered_count}名 / 定員#{capacity}名（#{status_label}）"
  end

  puts "🎉 合計 #{created_events.size}件のデモイベントが作成されました"
end