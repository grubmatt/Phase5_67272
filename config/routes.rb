Rails.application.routes.draw do
  # Routes for main resources
  resources :stores
  resources :employees
  resources :assignments
  resources :users
  resources :sessions
  resources :store_flavors
  resources :shifts 
  resources :shift_jobs
  
  # Semi-static page routes
  get 'home' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy

  get 'user/edit' => 'users#edit', :as => :edit_current_user
  get 'signup' => 'users#new', :as => :signup
  get 'login' => 'sessions#new', :as => :login
  get 'logout' => 'sessions#destroy', :as => :logout

  get 'new_store_flavor/:store_id' => 'store_flavors#new', :as => :new_store_flavor_for_store
  get 'new_shift_job/:shift_id' => 'shift_jobs#new', :as => :new_shift_job_for_shift

  
  # Set the root url
  root :to => 'home#home'  
  
end
