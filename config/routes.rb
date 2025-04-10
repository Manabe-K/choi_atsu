Rails.application.routes.draw do
  root to: "static_pages#top"

  # Omniauthのコールバックルート
  get "auth/:provider/callback", to: "sessions#omniauth_callback"

  # ログイン・ログアウト用のルート
  delete "logout" => "sessions#destroy"
  post "back_to_users", to: "sessions#back_to_users"

  # その他のリソース
  resources :tags
  resources :users
  resources :events
end
