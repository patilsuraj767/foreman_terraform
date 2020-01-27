require File.expand_path('../lib/foreman_terraform/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'foreman_terraform'
  s.version     = ForemanTerraform::VERSION
  s.license     = 'GPL-3.0'
  s.authors     = ['Suraj Patil']
  s.email       = ['patilsuraj767@gmail.com']
  s.homepage    = ''
  s.summary     = 'Summary of ForemanTerraform.'
  # also update locale/gemspec.rb
  s.description = 'Description of ForemanTerraform.'

  s.files = Dir['{app,config,db,lib,locale}/**/*'] + ['LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rdoc'
end
