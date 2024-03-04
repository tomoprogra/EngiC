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
      delete :destroy
      get :show_following
      get :show_followers
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

  get "privacy_policy", to: "tops#privacy_policy"
  get "terms_of_use", to: "tops#terms_of_use"
  get "release_note", to: "tops#release_note"

  get "/:username", to: "users#resolve_username", as: :resolve_username

  get "up" => "rails/health#show", as: :rails_health_check
end
