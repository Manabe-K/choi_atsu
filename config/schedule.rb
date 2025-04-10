every 1.day, at: '4:30 am' do
  runner "ActiveRecord::SessionStore.clear_expired_sessions"
end