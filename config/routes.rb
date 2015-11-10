Rails.application.routes.draw do
  root 'questions#index'

  resources 'questions', except: ['edit', 'update', 'destroy'] do
    resources 'answers', except: ['edit', 'update', 'destroy']
  end
end
