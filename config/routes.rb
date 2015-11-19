Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  concern :voteable do
    post 'vote_up', on: :member
    post 'vote_down', on: :member
  end

  resources 'questions', concerns: :voteable, except: [:edit] do
    resources 'answers', concerns: :voteable, except: [:index, :show, :edit] do
      post 'best_answer', on: :member
    end
  end
end
