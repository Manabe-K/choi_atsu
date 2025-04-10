if Rails.env.production?
  load Rails.root.join('db/seeds/guest_user.rb')
else

  # ゲストユーザー
  guest_user = User.find_or_create_by!(name: "ゲストユーザー") do |user|
    user.github_uid = "guest_uid"
    user.profile_picture = "https://example.com/guest.png"
    user.github_token = "dummy_token"
  end

  # タグ
  tag_names = %w[勉強会 交流会 オンライン 対面 ハンズオン 初心者歓迎]
  tags = tag_names.map { |name| Tag.find_or_create_by!(name: name) }

  # サンプルイベント
  3.times do |i|
    event = Event.create!(
      title: "サンプルイベント#{i + 1}",
      start_time: Time.current + (i + 1).days,
      end_time: Time.current + (i + 1).days + 2.hours,
      deadline: Time.current + i.days + 12.hours,
      location: ["オンライン", "渋谷", "大阪"].sample,
      description: "これはサンプルイベント#{i + 1}の説明です。",
      capacity: [10, 20, 30].sample,
      host_user_id: guest_user.id
    )

    event.tags << tags.sample(2)
  end
end