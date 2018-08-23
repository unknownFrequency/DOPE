Rails.application.routes.draw do
  resources :jobs
  root 'welcome#index'
  get 'welcome/index'

  get 'login', to: 'users#index'
  post 'login', to: 'users#login'

end
