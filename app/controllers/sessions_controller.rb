class SessionsController < ApplicationController
  def omniauth_callback
    auth = request.env["omniauth.auth"]

    github_username = auth.info.nickname
    is_member = GithubOrgMemberCheckService.new(github_username: github_username).member?

    if is_member
      user = User.find_by(github_uid: auth["uid"])

      if user
        session[:user_id] = user.id
        redirect_to events_path, notice: "ログインしました。"
      else
        # ユーザー登録情報をセッションに保存して、users#newへ
        session[:user_registration] = {
          name: auth.info.name,
          github_uid: auth.uid,
          github_token: auth.credentials.token,
          profile_picture: auth.info.image
        }
        redirect_to new_user_path, notice: "ユーザー登録を完了してください。"
      end
    else
      redirect_to root_path, alert: "RunTeqメンバーのみ登録可能です。"
    end
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
    redirect_to root_path, notice: "ユーザー登録をキャンセルしました。"
  end

  # sessions_controller.rb
  def demo_login
    demo_user = User.create!(
      name: "デモユーザー",
      github_uid: "demo_#{SecureRandom.hex(10)}",
      github_token: SecureRandom.hex(20),
      profile_picture: ActionController::Base.helpers.asset_path("demo_image.png")
    )
    session[:user_id] = demo_user.id
    redirect_to events_path, notice: "デモモードでログインしました"
  end
end
