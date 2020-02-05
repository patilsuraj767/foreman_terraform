Rails.application.routes.draw do
  #get 'index', to: "foreman_terraform/projects#index"
  # post "new" to: "foreman_terraform/projects#new"
  
  	resources :terraform_projects
    resources :terraform_modules do
      collection do
        post 'upload' , action: :upload, controller: 'terraform_modules'
      end
  end
  resources :terraform_environments
   
end
