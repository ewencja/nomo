Rails.application.routes.draw do
  root 'pages#home'
  get 'pages/gender'
  post 'names/soundex'
  post 'names/selection'
  post 'pages/results'
  get '/reset', to: 'pages#reset_session'
  get 'pages/home'
  get 'pages/results', to: 'pages#results'
  post 'names/name_search'
  get 'names/name_search'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
