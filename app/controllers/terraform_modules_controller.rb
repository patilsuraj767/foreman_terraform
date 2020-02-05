class TerraformModulesController < ::ApplicationController

	before_action :set_module, only: [:destroy]

	@@moduleStroagePath = "/etc/foreman-terraform/modules"


	def module_params
      params.require(:module)
    end

    def index
    	@modules = TerraformModule.all
    end
	
	def upload
		uploadModule
		terraformModuleName = extractTarFile("/var/tmp/#{module_params.original_filename}", @@moduleStroagePath)
		@module = TerraformModule.create(:name => terraformModuleName)
	end	


	def uploadModule
		uploaded_file = module_params
		puts uploaded_file.inspect
		if uploaded_file.content_type == "application/gzip"
			File.open(File.join('/var/tmp', uploaded_file.original_filename), 'wb') do |file|
				file.write(uploaded_file.read)
			end
			## Need code refactoring here, success message should be displayed after extractTarFile function or after saving module data to DB. 
			process_success(:success_msg => _("Module successfully uploaded ."), :success_redirect => terraform_modules_path)
		else
			process_error(:error_msg => _("Only .tar.gz files can be uploaded"), :redirect => terraform_modules_path)
		end
	end

	def extractTarFile(source, destination)
		root_directory = 0 
		root_directory_name = ''
		Gem::Package::TarReader.new( Zlib::GzipReader.open source ) do |tar|
			dest = nil
			tar.each do |entry|
				dest ||= File.join destination, entry.full_name
				if root_directory == 0
					root_directory_name = entry.full_name
					root_directory = 1
				end 
				if entry.directory?
					File.delete dest if File.file? dest
					FileUtils.mkdir_p dest, :mode => entry.header.mode, :verbose => false
				elsif entry.file?
					FileUtils.rm_rf dest if File.directory? dest
					File.open dest, "wb" do |f|
						f.print entry.read
					end
					FileUtils.chmod entry.header.mode, dest, :verbose => false
    			elsif entry.header.typeflag == '2' #Symlink!
    				File.symlink entry.header.linkname, dest
   	 			end
   				dest = nil
			end
		end

		## Deleting uploaded tar.gz after extraction.
		FileUtils.rm_f(source)

		return root_directory_name.chomp('/')
	end

	def removeModule
		modulepath = File.join(@@moduleStroagePath, @module.name)
		FileUtils.remove_dir(modulepath, true) if File.directory?(modulepath)
	end 

	def destroy
		removeModule
    	@module.destroy
    	respond_to do |format|
      		format.html { redirect_to :action => "index", notice: 'Post was successfully destroyed.' }
      		format.json { head :no_content }
    	end
  	end
  	
  	def set_module
      @module = TerraformModule.find(params[:id])
    end

end
