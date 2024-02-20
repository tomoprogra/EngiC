Rails.application.routes.draw do
  root to: "tops#index"

  devise_for :users, controllers: {
    registrations: "users/registrations",
    passwords: "users/passwords",
    sessions: "users/sessions",
    omniauth_callbacks: "users/omniauth_callbacks",
  }

  resources :users do
    member do
      get :show_follows
    end
    resource :skills, only: [:create, :destroy, :update]
    resource :mypage, only: [:show] do
      collection do
        get :qrcode
      end
      resources :items, only: [:index, :destroy, :create] do
        collection do
          post :save_order
        end
      end
    end
    resources :relationships, only: [:create, :destroy, :index]
    get "edit_username", to: "users#edit_username"
    patch "update_username", to: "users#update_username"
  end

  get "/:username", to: "users#resolve_username", as: :resolve_username
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
