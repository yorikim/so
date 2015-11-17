Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  resources 'questions', except: [:edit] do
    resources 'answers', except: [:index, :show, :edit]
    post 'answers/:id/best_answer' => 'answers#best_answer'
  end
end
