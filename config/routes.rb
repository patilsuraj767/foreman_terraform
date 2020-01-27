Rails.application.routes.draw do
  get 'index', to: 'foreman_terraform/projects#index'
end
