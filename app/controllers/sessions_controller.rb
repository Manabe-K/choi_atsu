class SessionsController < ApplicationController
  def new
    # 認証情報がない場合、空のユーザーインスタンスを作成
    @user = User.new
  end

  def omniauth_callback
    auth_info = request.env["omniauth.auth"]
    @user = User.find_or_initialize_by(github_uid: auth_info["uid"])
    @user.assign_attributes(
      name: auth_info["info"]["name"],
      github_token: auth_info["credentials"]["token"],
      profile_picture: auth_info["info"]["image"]
    )

    if user_is_member_of_runteq?(@user.github_token)
      if @user.persisted?
        # 既に登録済み → ログイン状態にしてリダイレクト
        session[:user_id] = @user.id
        redirect_to events_path, notice: "ログインしました。"
      else
        # 新規ユーザー → セッションに一時保存して登録画面へ
        session[:user_registration] = {
          github_uid: @user.github_uid,
          name: @user.name,
          github_token: @user.github_token,
          profile_picture: @user.profile_picture
        }
        redirect_to new_user_path
      end
    else
      flash[:error] = "You must be a member of RunTeq to register."
      redirect_to root_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "ログアウトしました"
  end

  def back_to_users
    session.delete(:user_registration)
    redirect_to root_path  # 例: ログイン画面へ
  end

  def guest_login
    guest_user = User.find_by(github_uid: "guest")
    if guest_user
      session[:user_id] = guest_user.id
      redirect_to events_path, notice: "ゲストユーザーとしてログインしました"
    else
      redirect_to root_path, alert: "ゲストユーザーが見つかりません"
    end
  end

  private

  def user_is_member_of_runteq?(github_token)
    # GitHub APIを使用して、ユーザーがRunTeqのメンバーか確認
    begin
      response = Faraday.get("https://api.github.com/orgs/runteq/members", headers: { "Authorization" => "token #{github_token}" })
      response.status == 200 # メンバーであればステータス200を返す
    rescue Faraday::ConnectionFailed => e
      # 接続エラーが発生した場合のエラーハンドリング
      Rails.logger.error("RunTeqメンバー確認APIへの接続に失敗しました: #{e.message}")
      false
    end
  end
end
