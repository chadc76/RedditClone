Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :users, only: %i(show new create)

  resource :session, only: %i(new create destroy)

  resources :subs do 
    member do
      post 'subscribe'
      post 'unsubscribe'
    end
  end

  resources :posts, except: [:index] do
    resources :comments, only: [:new]
    member do
      post 'upvote'
      post 'downvote'
    end
  end

  resources :comments, only: [:create, :show] do
    member do
      post 'upvote'
      post 'downvote'
    end
  end

  resource :search_results, only: %i(show)
end
