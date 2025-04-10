class SessionsController < ApplicationController
  def omniauth_callback
    auth_info = request.env["omniauth.auth"]
    @user = User.find_or_initialize_by(github_uid: auth_info["uid"])
    @user.assign_attributes(
      name: auth_info["info"]["name"],
      github_token: auth_info["credentials"]["token"],
    )

    if user_is_member_of_runteq?(@user.github_token)
      if @user.persisted?
        # ログイン処理
        session[:user_id] = @user.id
        redirect_to events_path, notice: "ログインしました。"
      else
        # 新規ユーザー登録画面に遷移
        session[:user_registration] = @user.slice(:github_uid, :name, :github_token)
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

  private

  def user_is_member_of_runteq?(github_token)
    begin
      response = Faraday.get("https://api.github.com/orgs/runteq/members", headers: { "Authorization" => "token #{github_token}" })
      response.status == 200
    rescue Faraday::ConnectionFailed => e
      Rails.logger.error("RunTeqメンバー確認APIへの接続に失敗しました: #{e.message}")
      false
    end
  end
end
