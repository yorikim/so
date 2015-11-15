Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  resources 'questions', except: ['edit'] do
    resources 'answers', except: ['edit', 'update']
  end
end
