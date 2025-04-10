class SessionsController < ApplicationController
  def omniauth_callback
    auth = request.env['omniauth.auth']
    @user = User.find_or_initialize_by(github_uid: auth['uid'])

    # ユーザー情報を更新（新規登録もしくは既存ユーザー）
    @user.assign_attributes(
      name: auth['info']['name'],
      github_token: auth['credentials']['token'],
      profile_picture: auth['info']['image']
    )

    # 新規ユーザーか既存ユーザーかを判定
    is_new_user = @user.new_record?

    # RunTeqメンバー確認
    if user_is_member_of_runteq?(@user.github_token)
      if is_new_user && @user.save
        session[:user_id] = @user.id  # ログイン状態に設定
        redirect_to edit_user_path(@user), notice: 'ユーザー登録が完了しました。'
      elsif !is_new_user && @user.save
        session[:user_id] = @user.id  # ログイン状態に設定
        redirect_to events_path, notice: 'ログインしました。'
      else
        redirect_to root_path, alert: 'ユーザー登録に失敗しました。'
      end
    else
      redirect_to root_path, alert: 'You must be a member of RunTeq to register.'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'ログアウトしました'
  end

  private

  # RunTeqメンバーかどうかのチェック
  def user_is_member_of_runteq?(github_token)
    response = Faraday.get("https://api.github.com/orgs/runteq/members", 
                           headers: { "Authorization" => "token #{github_token}" })
    response.status == 200
  rescue Faraday::ConnectionFailed => e
    Rails.logger.error("RunTeqメンバー確認APIへの接続に失敗しました: #{e.message}")
    false
  end
end