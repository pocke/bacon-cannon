Rails.application.routes.draw do
  root 'root#index'
  post '/parse', controller: 'root', action: 'parse'

  resources :permlinks, only: %i[show create]
end
