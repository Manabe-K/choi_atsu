Rails.application.routes.draw do
  resources :tags
  resources :users
  root "static_pages#top"
  resources :events
end
