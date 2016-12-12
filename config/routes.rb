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
  get '/names/', to: 'names#names'

  get 'frequency/:name', to: 'pages#frequency_by_name', constraints: { format: :json }
  get 'names/:gender', to: 'names#names_search', constraints: { format: :json }
  get 'origins', to: 'origins#origins'
  post '/names_suggestions', to: 'names#names_suggestions'
end
