Rails.application.routes.draw do
  resources :reminders, only: [:index, :create]
  root to: "home_pages#show"
end
