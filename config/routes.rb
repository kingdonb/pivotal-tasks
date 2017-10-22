Rails.application.routes.draw do
  get 'my_dashboard/index'

  resources :dashboards
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'my_dashboard#index'
end
