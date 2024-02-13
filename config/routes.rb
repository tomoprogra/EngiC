Rails.application.routes.draw do
  root to: "tops#index"

  devise_for :users, controllers: {
    registrations: "users/registrations",
    passwords: "users/passwords",
    sessions: "users/sessions",
    omniauth_callbacks: "users/omniauth_callbacks",
  }

  resources :mypages do
    resources :items do
      collection do
        post :save_order
      end
    end
  end

  devise_scope :user do
    get 'users/auth/:provider/upgrade', to: 'users/omniauth_callbacks#upgrade', as: :user_omniauth_upgrade
    resources :relationships, only:[:create, :destroy]
    get 'follows' => 'relationships#follower', as: :user_follower
    get 'followers' => 'relationships#followed', as: :user_followed
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
