Rails.application.routes.draw do
  # トップページ
  root to: "static_pages#top"

  # セッション関連（ログイン・ログアウト・デモログイン）
  get    "auth/:provider/callback", to: "sessions#omniauth_callback"
  delete "logout",                  to: "sessions#destroy"
  post   "back_to_users",           to: "sessions#back_to_users"
  get    "demo_login",              to: "sessions#demo_login"

  # リソース系（必要なアクションだけ許可）
  get "/users/search", to: "users#search"
  resources :users, except: [ :index ] do
    member do
      delete :delete_uploaded_picture
    end
  end
  resources :events do
    collection do
      get :participating
      get :interested
    end
    member do
      get :curious_users
    end
    resource :participant, only: [ :create, :destroy ]
    resource :curious_list, only: [ :create, :destroy ]
    resources :thread_posts, only: [ :create, :edit, :update, :destroy, :show ]
  end
  resources :user_tags, only: [ :create, :destroy ]
  get "tags/search", to: "tags#search"
  resources :tags, only: [ :index, :show ] do
    get :users, on: :member
  end
  get "/mypage", to: "my_pages#show"

  # sessionの定期的な削除
  get "/clear_sessions/:token", to: "maintenance#clear_sessions", as: :secure_clear_sessions
  get "/reset_demo_data/:token", to: "maintenance#reset_demo_data", as: :reset_demo_data

  namespace :howto do
    get "profile", to: "pages#profile"
    get "plan", to: "pages#plan"
    get "offline", to: "pages#offline"
    get "curious", to: "pages#curious"
    get "notification", to: "pages#notification"
  end

  mount ActionCable.server => '/cable'
end
