Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: "users/registrations", omniauth_callbacks: 'omniauth_callbacks'}
  devise_scope :user do
    get '/users/require_email' => 'users/registrations#require_email', :as => :require_email
    post '/users/submit_email' => 'users/registrations#submit_email', :as => :submit_email
  end

  root 'questions#index'

  concern :voteable do
    post 'vote_up', on: :member
    post 'vote_down', on: :member
  end

  concern :commentable do
    resources :comments #, only: [:create]
  end

  resources :questions, concerns: [:voteable, :commentable], except: [:edit], shallow: true do
    resources :answers, concerns: [:voteable, :commentable], except: [:index, :show, :edit] do
      post 'make_best', on: :member
    end
  end
end
