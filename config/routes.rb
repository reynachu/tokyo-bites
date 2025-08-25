Rails.application.routes.draw do
  get 'plans/index'
  get "map", to: "pages#map", as: :map
  get "profile", to: "users#profile", as: :profile
  get "search", to: "search#index", as: :search

  devise_for :users
  root to: "pages#home"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  resources :restaurants, only: [:index, :show] do
    resources :recommendations, only: [:index, :new, :create]
    collection do
      get :map
    end

  # Bookmark routes (POST + DELETE only)
    resource :bookmarks, only: [:create, :destroy, :show]
  end


  resources :wishlists, only: [:index, :create, :destroy]   # 👈 THIS gives you wishlists_path


  # unnested recommendation resource
  resources :recommendations, only: [:index, :new, :create]

  # Global recommendations index (all restaurants)
  # resources :recommendations, only: [:index]

  # plans
  resources :plans, only: [:index]

  # users
  resources :users, only: [:show, :index] do
    post 'follow', to: 'socializations#follow', as: :follow
    delete 'unfollow', to: 'socializations#unfollow', as: :unfollow

    member do
      get :wishlist
    end
  end
end
