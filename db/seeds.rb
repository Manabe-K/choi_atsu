demo_host = User.find_or_create_by!(
  github_uid: "demo_seed_user"
) do |user|
  user.name = "デモデータホスト"
  user.github_token = "dummy_token"
  user.profile_picture = "demo_image.png"
end

# タグ1〜10を先に作る（イベントより前に）
(1..10).each do |i|
  Tag.find_or_create_by!(name: "タグ#{i}")
end

# ここでタグIDを取得しておく
sample_tags = Tag.pluck(:id)

# ここからイベント作成（is_sampleは使わない）
if Event.where(host_user: demo_host).count < 10
  puts "✅ サンプルイベントを作成します"

  10.times do |i|
    start_time = Time.current + (i + 1).days
    end_time = start_time + (1 + rand(2)).hours

    event = Event.create!(
      title: "サンプルイベント#{i + 1}:#{['ランチ会', '勉強会', '雑談会'].sample}",
      start_time: start_time,
      end_time: end_time,
      deadline: start_time - 1.day,
      location: ['オンライン', '渋谷', '大阪'].sample,
      description: "これはデモ用イベントです。",
      capacity: rand(5..15),
      host_user: demo_host
    )

    # タグを1〜3個ランダムに付ける（必ず1個以上）
    event.tag_ids = sample_tags.sample(rand(1..3))
  end
else
  puts "⚠️ サンプルイベントはすでに作成済みのためスキップされました"
end
