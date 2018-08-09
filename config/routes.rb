Rails.application.routes.draw do
  resources :jobs
  root 'welcome#index'
  get 'welcome/index'

end
