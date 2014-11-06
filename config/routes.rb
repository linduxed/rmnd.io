Rails.application.routes.draw do
  resources :reminders, only: [:index, :create]
  root to: "high_voltage/pages#show", id: "landing"
end
