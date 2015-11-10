Rails.application.routes.draw do
  resources 'questions', except: ['edit', 'update', 'destroy']
end
