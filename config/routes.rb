Rails.application.routes.draw do
  # Health check (Keep this at the top)
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Authentication
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }

  # Root path
  #  Point root to pages#home so the "redirect if signed in" logic runs
  root 'pages#home' 

  # Application Resources
  resource :dashboard, only: [:show], controller: 'dashboards'
  
  resources :standups do
    resources :comments, only: [:create, :destroy]
  end

  resources :teams, only: [:index, :show]

  namespace :users do
    resource :profile, only: [:show, :edit, :update]
  end

  # API Routes
  namespace :api do
    namespace :v1 do
      resources :teams, only: [] do
        member do
          get :standups_today
          get :blockers
        end
        
        resources :standups, only: [] do
          collection do
            get :today
          end
        end
      end
    end
  end
end