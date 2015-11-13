Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  resources 'questions', except: ['edit', 'update'] do
    resources 'answers', except: ['edit', 'update']
  end
end
