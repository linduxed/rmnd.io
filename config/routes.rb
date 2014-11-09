Rails.application.routes.draw do
  resource :session, only: [:create]
  resources :users, only: Clearance.configuration.user_actions do
    resource :password,
      controller: "clearance/passwords",
      only: [:create, :edit, :update]
    get "email_confirmations/:token",
      to: "email_confirmations#update",
      as: :email_confirmation
  end
  resources :reminders, only: [:index, :create] do
    resource :cancellation, only: [:create]
  end
  root to: "home_pages#show"
end
