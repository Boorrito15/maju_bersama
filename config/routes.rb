Rails.application.routes.draw do
  # devise_for :users
  # devise routes
  devise_for :users, skip: [:sessions, :registrations, :passwords], controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  as :user do
    # Custom session routes
    get 'login', to: 'users/sessions#new', as: :new_user_session
    post 'login', to: 'users/sessions#create', as: :user_session
    match 'logout', to: 'users/sessions#destroy', as: :destroy_user_session, via: Devise.mappings[:user].sign_out_via

    # Custom registration routes
    get 'sign_up', to: 'users/registrations#new', as: :new_user_registration
    post 'sign_up', to: 'users/registrations#create', as: :user_registration

    # Custom password routes
    get 'password/new', to: 'users/passwords#new', as: :new_user_password
    post 'password/email', to: 'users/passwords#create', as: :user_password
    get 'password/edit', to: 'users/passwords#edit', as: :edit_user_password
    put 'password', to: 'users/passwords#update', as: :update_user_password
  end

  resources :events
  resources :event_registrations, only: [:index, :create, :destroy]

  resources :candidates do
    resources :experiences, only: [:create, :update]
    resources :candidate_disabilities, only: [:create, :update, :destroy]
  end
  resources :employers
  resources :jobs
  resources :job_applications, only: [:index, :create, :destroy]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  get '/playground', to: 'pages#playground'
  get 'pages/home', to: 'pages#home', as: 'pages_home'
  root to: 'pages#home'

end
