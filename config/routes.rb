Rails.application.routes.draw do
  resources :jobs
  root 'welcome#index'
  get 'welcome/index'

  get 'login', to: 'users#index'
  post 'login', to: 'users#login'

  get '/oauth/callback', to: 'data#create_session'
  get 'session', to: 'data#create_session'
  # get 'index', to: 'data#index'

end
