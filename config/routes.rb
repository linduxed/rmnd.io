Rails.application.routes.draw do
  resource :session, only: [:create]
  resources :reminders, only: [:index, :create]
  root to: "home_pages#show"
end
