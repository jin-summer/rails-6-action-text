Rails.application.routes.draw do
  resources :users, only: [:index, :show, :new, :edit, :create, :update]
  resources :sessions, only: [:new, :create, :destroy]
  resources :posts
  root 'top#index'
  match 'signup', to: 'users#new', via: 'get'
  match 'signin', to: 'sessions#new', via: 'get'
  match 'signout', to: 'sessions#destroy', via: 'delete'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
