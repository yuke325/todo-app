Rails.application.routes.draw do
  root 'home#index'

  resources :tasks, except: [:show]
end
