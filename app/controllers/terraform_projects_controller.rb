
 
  class TerraformProjectsController < ::ApplicationController

    before_action :set_project, only: [:destroy]

    def index
      @projects = TerraformProject.all	
    end

    def new
    	@project = TerraformProject.new
    end

    def create
    	@project = TerraformProject.new(project_params)
    	
      	if @project.save
          process_success(:success_msg => _("Project was successfully created."), :success_redirect => terraform_projects_path)
        
        	
      else
        process_error(:error_msg => _("Unable to create new project"), :redirect => terraform_modules_path)
      end
    

    end

    def project_params
      params.require(:terraform_project).permit(:name)
    end

    def destroy
    
      if @project.destroy
        process_success(:success_msg => _("Project deleted successfully."), :success_redirect => terraform_projects_path)
      else
         process_error(:error_msg => _("Unable to delete the project"), :redirect => terraform_modules_path)
      end  
      
    end
  
    def set_project
      @project = TerraformProject.find(params[:id])
    end

  end

