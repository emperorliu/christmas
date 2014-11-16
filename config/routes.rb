Rails.application.routes.draw do
 get 'ui/(:action)', controller: 'ui'

 root to: 'sessions#new'
 resources :sessions, only: [:create]
 get '/logout', to: 'sessions#destroy'

 get '/register', to: 'users#new'
 resources :users, only: [:create]

 resources :ideas, only: [:index, :new, :create, :destroy]

 get '/home', to: 'liked_items#index'
 resources :liked_items, only: [:create]
end
