require 'rake/testtask'

# Tasks
namespace :foreman_terraform do
  namespace :example do
    desc 'Example Task'
    task task: :environment do
      # Task goes here
    end
  end
end

# Tests
namespace :test do
  desc 'Test ForemanTerraform'
  Rake::TestTask.new(:foreman_terraform) do |t|
    test_dir = File.join(File.dirname(__FILE__), '../..', 'test')
    t.libs << ['test', test_dir]
    t.pattern = "#{test_dir}/**/*_test.rb"
    t.verbose = true
    t.warning = false
  end
end

namespace :foreman_terraform do
  task :rubocop do
    begin
      require 'rubocop/rake_task'
      RuboCop::RakeTask.new(:rubocop_foreman_terraform) do |task|
        task.patterns = ["#{ForemanTerraform::Engine.root}/app/**/*.rb",
                         "#{ForemanTerraform::Engine.root}/lib/**/*.rb",
                         "#{ForemanTerraform::Engine.root}/test/**/*.rb"]
      end
    rescue
      puts 'Rubocop not loaded.'
    end

    Rake::Task['rubocop_foreman_terraform'].invoke
  end
end

Rake::Task[:test].enhance ['test:foreman_terraform']

load 'tasks/jenkins.rake'
if Rake::Task.task_defined?(:'jenkins:unit')
  Rake::Task['jenkins:unit'].enhance ['test:foreman_terraform', 'foreman_terraform:rubocop']
end
