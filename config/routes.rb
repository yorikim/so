Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  resources 'questions', except: ['edit', 'update', 'destroy'] do
    resources 'answers', except: ['edit', 'update', 'destroy']
  end


end
