class SessionsController < ApplicationController
  def omniauth_callback
    puts "=== omniauth_callback start ==="

    auth = request.env['omniauth.auth']
    puts "Auth received: UID=#{auth['uid']}, Name=#{auth['info']['name']}"

    @user = User.find_or_initialize_by(github_uid: auth['uid'])

    @user.assign_attributes(
      name: auth['info']['name'],
      github_token: auth['credentials']['token'],
      profile_picture: auth['info']['image']
    )

    is_new_user = @user.new_record?
    puts "Is new user: #{is_new_user}"

    # GitHubのusername（nickname）を使ってRunTeqのメンバーか確認
    github_username = auth.info.nickname
    is_member = GithubOrgMemberCheckService.new(github_username: github_username).member?
    puts "RunTeq member check: #{is_member}"

    if is_member
      if @user.save
        session[:user_id] = @user.id
        redirect_path = is_new_user ? edit_user_path(@user) : events_path
        redirect_to redirect_path, notice: is_new_user ? 'ユーザー登録が完了しました。' : 'ログインしました。'
      else
        puts "User save failed: #{@user.errors.full_messages}"
        redirect_to root_path, alert: 'ユーザー登録に失敗しました。'
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
end