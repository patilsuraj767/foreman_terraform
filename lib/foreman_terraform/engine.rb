module ForemanTerraform
  class Engine < ::Rails::Engine
    engine_name 'foreman_terraform'

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/overrides"]

    # Add any db migrations
    initializer 'foreman_terraform.load_app_instance_data' do |app|
      ForemanTerraform::Engine.paths['db/migrate'].existent.each do |path|
        app.config.paths['db/migrate'] << path
      end
    end

    initializer 'foreman_terraform.register_plugin', :before => :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_terraform do
        requires_foreman '>= 1.16'

        # Add permissions
        security_block :foreman_terraform do
          permission :view_foreman_terraform, :'foreman_terraform/hosts' => [:new_action]
        end

        # Add a new role called 'Discovery' if it doesn't exist
        role 'ForemanTerraform', [:view_foreman_terraform]

        # add menu entry
        divider :top_menu, :caption => N_('Terraform'), :parent => :infrastructure_menu

        menu :top_menu, :terraform,
             :caption => N_('Projects'),
             url_hash: { :controller => 'terraform_projects', :action => :index },
             parent: :infrastructure_menu

        menu :top_menu, :modules,
             :caption => N_('Modules'),
             url_hash: { :controller => 'terraform_modules', :action => :index },
             parent: :infrastructure_menu
             

        # add dashboard widget
        widget 'foreman_terraform_widget', name: N_('Foreman plugin template widget'), sizex: 4, sizey: 1
      end
    end

    # Include concerns in this config.to_prepare block
    config.to_prepare do
      begin
        Host::Managed.send(:include, ForemanTerraform::HostExtensions)
        HostsHelper.send(:include, ForemanTerraform::HostsHelperExtensions)
      rescue => e
        Rails.logger.warn "ForemanTerraform: skipping engine hook (#{e})"
      end
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanTerraform::Engine.load_seed
      end
    end

    initializer 'foreman_terraform.register_gettext', after: :load_config_initializers do |_app|
      locale_dir = File.join(File.expand_path('../../..', __FILE__), 'locale')
      locale_domain = 'foreman_terraform'
      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end
  end
end
