class MaintenanceController < ApplicationController
  def clear_sessions
    return head :forbidden unless Rails.env.production?
    return head :unauthorized unless params[:token] == ENV["CRON_SECRET_TOKEN"]

    expired_sessions = ActiveRecord::SessionStore::Session.where("updated_at < ?", 2.hours.ago)
    expired_user_ids = expired_sessions.map { |s| extract_user_id(s) }.compact.uniq
    expired_sessions.delete_all

    User.where("github_uid LIKE ?", "demo_%")
        .where.not(github_uid: demo_seed_user_ids)
        .where(id: expired_user_ids)
        .find_each do |user|
      user.hosted_events.destroy_all
      user.destroy
    end

    render plain: "✅ 期限切れセッション & demoユーザーを削除しました"
  end

  def reset_demo_data
    return head :forbidden unless Rails.env.production?
    return head :unauthorized unless params[:token] == ENV["CRON_SECRET_TOKEN"]

    Event.joins(:host_user).where("users.github_uid LIKE ?", "demo_seed_user%").destroy_all
    load Rails.root.join("db/seeds/demo_events.rb")

    render plain: "✅ デモイベントをリセットして再生成しました"
  end

  private

  def extract_user_id(session)
    Marshal.load(session.data)["user_id"]
  rescue
    nil
  end

  def demo_seed_user_ids
    (1..5).map { |i| "demo_seed_user#{i}" }
  end
end
