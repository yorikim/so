Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  concern :voteable do
    post 'vote_up', on: :member
    post 'vote_down', on: :member
  end

  concern :commentable do
    resources :comments#, only: [:create]
  end

  resources :questions, concerns: [:voteable, :commentable], except: [:edit], shallow: true do
    resources :answers, concerns: [:voteable, :commentable], except: [:index, :show, :edit] do
      post 'make_best', on: :member
    end
  end
end
