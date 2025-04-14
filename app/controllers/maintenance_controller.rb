class MaintenanceController < ApplicationController
  def clear_sessions
    return head :forbidden unless Rails.env.production?
    return head :unauthorized unless params[:token] == ENV["CRON_SECRET_TOKEN"]

    expired_sessions = ActiveRecord::SessionStore::Session.where("updated_at < ?", 2.hours.ago)
    expired_user_ids = expired_sessions.map { |s| extract_user_id(s) }.compact.uniq
    expired_sessions.delete_all

    User.where("github_uid LIKE ?", "demo_%")
        .where(id: expired_user_ids)
        .find_each do |user|
      user.hosted_events.destroy_all
      user.destroy
    end

    render plain: "✅ 期限切れセッション & demoユーザーを削除しました"
  end

  private

  def extract_user_id(session)
    Marshal.load(session.data)["user_id"]
  rescue
    nil
  end
end