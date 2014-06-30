Rails.application.routes.draw do
  use_doorkeeper

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :questions, controller: 'topics', except: [:destroy] do
    resources :answers, controller: 'messages',
              only: [:create, :edit, :update] do
      post :accept, on: :member
      post :voteup, on: :member
      post :votedown, on: :member
    end
  end

  resources :messages, only: [] do
    resources :comments, only: [:create]
  end

  resources :users, only: [:show, :edit, :update]

  resources :tags, only: [:index]

  namespace :api do
    namespace :v1 do
      resources :users, only: [:index] do
        get :me, on: :collection
      end
    end
  end

  root 'topics#home'
end
