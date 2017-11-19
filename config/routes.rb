Rails.application.routes.draw do
  get 'my_dashboard/index'
  get '/orphaned', to: 'my_dashboard#orphaned'

  get '/ping', to: 'application#ping', defaults: { :format => 'json' }

  resources :dashboards
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'my_dashboard#index'
end
