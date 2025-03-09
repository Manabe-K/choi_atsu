Rails.application.routes.draw do
  root "static_pages#top"
  resources :events
end
