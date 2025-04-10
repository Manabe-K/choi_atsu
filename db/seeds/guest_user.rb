guest_user = User.find_or_create_by!(name: "ゲストユーザー") do |user|
  user.github_uid = "guest_uid"
  user.profile_picture = "https://example.com/guest.png"
  user.github_token = "dummy_token"
end