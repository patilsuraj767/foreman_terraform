module ForemanTerraform
 
  class ProjectsController < ::ApplicationController

    def index
      @projects = ForemanTerraform::Project.all	
    end

    def new
    	@project = ForemanTerraform::Project.new
    end

    def create
    	@project = ForemanTerraform::Project.new(recipe_params)
    	respond_to do |format|
      	if @project.save
        	format.html { redirect_to :action => "index", notice: 'Recipe was successfully created.' }
        	format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end

    end

    def recipe_params
      params.require(:foreman_terraform_project).permit(:name)
    end

  end

end