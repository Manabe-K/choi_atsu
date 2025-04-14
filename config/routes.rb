Rails.application.routes.draw do
  # トップページ
  root to: "static_pages#top"

  # セッション関連（ログイン・ログアウト・デモログイン）
  get    "auth/:provider/callback", to: "sessions#omniauth_callback"
  delete "logout",                  to: "sessions#destroy"
  post   "back_to_users",           to: "sessions#back_to_users"
  get    "demo_login",              to: "sessions#demo_login"

  # リソース系（必要なアクションだけ許可）
  resources :users, except: [ :index ]
  resources :events do
    resource :participant, only: [ :create, :destroy ]
    resource :curious_list, only: [ :create, :destroy ]
  end
  resources :tags, only: [ :index, :show ] # 必要に応じて :new, :create, :edit, :update, :destroy を追加

  # sessionの定期的な削除
  get "/clear_sessions/:token", to: "maintenance#clear_sessions", as: :secure_clear_sessions
end
