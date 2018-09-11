Rails.application.routes.draw do
  resources :jobs
  root 'welcome#index'
  get 'welcome/index'

  get 'account', to: 'users#index'
  get 'login', to: 'users#login'
  get 'user/:id', to: 'users#show', as: 'user'
  post 'users', to: 'users#create'

  # get '/oauth/callback', to: 'data#create_session'
  get 'session', to: 'data#create_session'
  # get 'index', to: 'data#index'

  get 'contacts', to: 'dinero#contacts'

end
