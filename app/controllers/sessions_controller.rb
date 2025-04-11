class SessionsController < ApplicationController
  def omniauth_callback
    puts "=== omniauth_callback start ==="
  
    auth = request.env['omniauth.auth']
    puts "Auth received: UID=#{auth['uid']}, Name=#{auth['info']['name']}"
  
    @user = User.find_or_initialize_by(github_uid: auth['uid'])
  
    # ユーザー情報を更新
    @user.assign_attributes(
      name: auth['info']['name'],
      github_token: auth['credentials']['token'],
      profile_picture: auth['info']['image']
    )
  
    is_new_user = @user.new_record?
    puts "Is new user: #{is_new_user}"
  
    # RunTeqメンバー確認
    is_member = user_is_member_of_runteq?(@user.github_token)
    puts "RunTeq member check: #{is_member}"
  
    if is_member
      if is_new_user
        if @user.save
          puts "New user saved: ID=#{@user.id}"
          session[:user_id] = @user.id
          puts "Session set (new user): #{session[:user_id]}"
          redirect_to edit_user_path(@user), notice: 'ユーザー登録が完了しました。'
        else
          puts "New user save failed: #{@user.errors.full_messages}"
          redirect_to root_path, alert: 'ユーザー登録に失敗しました。'
        end
      else
        if @user.save
          puts "Existing user updated: ID=#{@user.id}"
          session[:user_id] = @user.id
          puts "Session set (existing user): #{session[:user_id]}"
          redirect_to events_path, notice: 'ログインしました。'
        else
          puts "Existing user save failed: #{@user.errors.full_messages}"
          redirect_to root_path, alert: 'ユーザー登録に失敗しました。'
        end
      end
    else
      puts "Not a RunTeq member, redirecting to root"
      redirect_to root_path, alert: 'You must be a member of RunTeq to register.'
    end
  
    puts "=== omniauth_callback end ==="
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