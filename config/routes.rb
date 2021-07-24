Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :users, only: %i(show new create)

  resource :session, only: %i(new create destroy)

  resources :subs

  resources :posts, except: [:index]
end
