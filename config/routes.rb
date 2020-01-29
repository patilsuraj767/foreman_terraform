Rails.application.routes.draw do
  #get 'index', to: "foreman_terraform/projects#index"
  # post "new" to: "foreman_terraform/projects#new"
  namespace :foreman_terraform do
  	resources :projects
  	resources :modules
  end
   
end
