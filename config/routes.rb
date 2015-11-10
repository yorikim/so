Rails.application.routes.draw do
  resources 'questions', except: ['edit', 'update', 'destroy'] do
    resources 'answers', except: ['edit', 'update', 'destroy']
  end
end
