require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "crud_star"
    gem.summary = "CrudStar"
    gem.description = "CrudStar"
    gem.email = "steve@stevelorek.com"
    gem.homepage = "http://github.com/slorek/crud_star"
    gem.authors = ["Steve Lorek"]
    gem.add_dependency('rails', '~> 3.0.1')
    gem.add_dependency('will_paginate', '>= 3.0.pre2')
    gem.add_dependency('formtastic', '~> 1.2.0.beta')
    gem.add_development_dependency('rspec', '~> 2.0.1')
    gem.files = Dir["{lib}/**/*", "{app}/**/*", "{config}/**/*", "{public}/**/*"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new do |spec|
  spec.name = :spec
  spec.pattern = 'spec/**/*_spec.rb'
  spec.ruby_opts = '-Ilib -Iapp'
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "crud_star #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
