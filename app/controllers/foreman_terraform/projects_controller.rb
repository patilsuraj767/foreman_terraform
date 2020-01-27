module ForemanTerraform
  # Example: Plugin's HostsController inherits from Foreman's HostsController
  class ProjectsController < ::ApplicationController
    # change layout if needed
    # layout 'foreman_terraform/layouts/new_layout'

    def index
      # automatically renders view/foreman_terraform/hosts/new_action
    end
  end
end
