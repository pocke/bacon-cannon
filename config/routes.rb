Rails.application.routes.draw do
  root 'root#index'
  post '/parse', controller: 'root', action: 'parse'

  resources :parmlinks, only: %i[show create]
end
