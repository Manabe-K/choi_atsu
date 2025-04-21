class SessionsController < ApplicationController
  def omniauth_callback
    auth = request.env["omniauth.auth"]
    github_username = auth.info.nickname
    is_member = GithubOrgMemberCheckService.new(github_username: github_username).member?

    unless is_member
      redirect_to root_path, alert: "RUNTEQメンバーのみ登録可能です。" and return
    end

    user = User.find_by(github_uid: auth.uid)

    if user
      login(user)
      redirect_to events_path(interested: 1, available: 1), notice: "ログインしました。"
    else
      prepare_user_registration(auth)
      redirect_to new_user_path, notice: "ユーザー登録を完了してください。"
    end
  end

  def demo_login
    demo_user = User.create!(
      name: "デモユーザー_#{SecureRandom.hex(2)}",
      github_uid: "demo_#{SecureRandom.hex(10)}",
      github_token: SecureRandom.hex(20),
      profile_picture: "demo_image_#{rand(6..10)}.png"
    )

    # 🔰 タグ登録（Tagがなければ作成）
    if Tag.count.zero?
      (1..10).each { |i| Tag.create!(name: "タグ#{i}") }
    end

    Tag.all.sample(3).each do |tag|
      UserTag.find_or_create_by!(user: demo_user, tag: tag)
    end

    # 🔰 イベント4種作成
    statuses = %w[開催済み 募集終了 満員 募集中]

    statuses.each do |status|
      start_time =
        status == "開催済み" ? 3.days.ago : 1.day.from_now
      end_time = start_time + 2.hours

      deadline =
        case status
        when "開催済み"
          4.days.ago
        when "募集終了"
          1.day.ago
        else
          start_time - 1.hour
        end

      capacity = 5

      event = Event.create!(
        title: "デモ#{status}イベント",
        start_time: start_time,
        end_time: end_time,
        deadline: deadline,
        location: %w[オンライン 渋谷 大阪 福岡 名古屋].sample,
        description: "#{status}イベントのサンプルです。",
        capacity: capacity,
        host_user: demo_user,
        tag_ids: Tag.all.sample(rand(1..3)).map(&:id)
      )

      Participant.create!(event: event, user: demo_user)

      others = User.where("github_uid LIKE ?", "demo_seed_user%")
                   .where.not(id: demo_user.id)
                   .sample(3)

      others.each_with_index do |u, i|
        if status == "満員" || (status == "募集中" && i.even?)
          Participant.find_or_create_by!(event: event, user: u)
        else
          CuriousList.find_or_create_by!(event: event, user: u)
        end
      end
    end

    login(demo_user)
    redirect_to events_path(interested: 1, available: 1), notice: "デモモードでログインしました"
  end

  def destroy
    if current_user&.demo?
      current_user.hosted_events.destroy_all
      current_user.destroy
    end
    reset_session
    redirect_to root_path, notice: "ログアウトしました"
  end

  def back_to_users
    session.delete(:user_registration)
    redirect_to root_path, alert: "ユーザー登録をキャンセルしました。"
  end

  private

  def login(user)
    session[:user_id] = user.id
  end

  def prepare_user_registration(auth)
    session[:user_registration] = {
      name: auth.info.name,
      github_uid: auth.uid,
      github_token: auth.credentials.token,
      profile_picture: auth.info.image
    }
  end
end
