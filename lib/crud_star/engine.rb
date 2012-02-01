require 'crud_star'
require 'crud_star/utility'

require 'rails'
require 'active_record'
require 'action_controller'

require 'will_paginate'
require 'formtastic'

module CrudStar
  class Engine < Rails::Engine
     
    config.application_name = 'CrudStar'
    config.url_path         = 'admin'
    config.theme            = 'green'
    config.navigation       = :dashboard
    config.use_cancan       = false
    config.ability_class    = nil
    config.additional_javascripts = nil
    
    # Enable the images, stylesheets and JavaScript files to be served in the parent app.
    initializer "static assets" do |app|
      app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
    end
    
    initializer 'register expansions' do
      ActionView::Helpers::AssetTagHelper.register_javascript_expansion :crud_star => ['https://ajax.googleapis.com/ajax/libs/jquery/1.4.3/jquery.min.js', 'https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.6/jquery-ui.min.js', 'rails', 'crud_star/application', 'jquery/ui/timepicker-addon-0.6.min.js']
    end
    
    initializer "formtastic" do
      require 'crud_star/formtastic/semantic_form_builder.rb'
      load 'crud_star/formtastic/initializer.rb'
    end

    # Load rake tasks
    rake_tasks do
      load 'crud_star/railties/crud_star.rake'
    end
  end
end
