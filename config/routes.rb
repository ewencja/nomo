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
  get 'name', to: 'names#name'

  get 'frequency/:name', to: 'pages#frequency_by_name', constraints: { format: :json }

end
