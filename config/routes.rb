Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }
 
  root 'pages#home'
 
  namespace :users do
    resource :profile, only: [:show, :edit, :update]
  end
 resource :dashboard, only: [:show]
  resources :standups, only: [:new, :create, :edit, :update, :destroy] do
    resources :comments, only: [:create, :destroy]
  end
 
  resources :teams, only: [:index, :show]
 
  # API routes (optional bonus for ST-10)
  namespace :api do
    namespace :v1 do
      resources :teams, only: [] do
        get :standups_today, on: :member
        get :blockers, on: :member
      end
    end
  end
 
  # Health check
  get 'up' => 'rails/health#show', as: :rails_health_check
end