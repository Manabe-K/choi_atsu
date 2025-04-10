class SessionsController < ApplicationController
  def omniauth_callback
    auth = request.env['omniauth.auth']

    # GitHubのUIDを使って、ユーザーが存在するか確認（新規ユーザーなら作成、既存ユーザーなら情報更新）
    @user = User.find_or_initialize_by(github_uid: auth['uid'])

    # ユーザーの情報を更新（新規登録でも既存ユーザーでも）
    @user.assign_attributes(
      name: auth['info']['name'],
      github_token: auth['credentials']['token'],
      profile_picture: auth['info']['image']
    )

    if user_is_member_of_runteq?(@user.github_token)
      if @user.save
        session[:user_id] = @user.id  # ユーザーをログイン状態に設定
        
        # 新規ユーザーの場合はeditページに、既存ユーザーの場合はevents#indexにリダイレクト
        if @user.new_record?
          redirect_to edit_user_path(@user), notice: 'ユーザー登録が完了しました。'
        else
          redirect_to events_path, notice: 'ログインしました。'
        end
      else
        redirect_to root_path, alert: 'ユーザー登録に失敗しました。'
      end
    else
      flash[:alert] = 'You must be a member of RunTeq to register.'
      redirect_to root_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'ログアウトしました'
  end

  private

  def user_is_member_of_runteq?(github_token)
    begin
      response = Faraday.get("https://api.github.com/orgs/runteq/members", headers: { "Authorization" => "token #{github_token}" })
      
      if response.status == 200
        return true
      else
        return false
      end
    rescue Faraday::ConnectionFailed => e
      Rails.logger.error("RunTeqメンバー確認APIへの接続に失敗しました: #{e.message}")
      false
    end
  end
end