module CrudStar
  class Utility
  
    def self.path_for_resource(resource)
      ar = [CrudStar::Engine.config.url_path, resource.to_s.singularize.parameterize, 'path'].delete_if {|i| i.nil? or i.to_s.empty?}
      ar.join('_')
    end
    
    def self.path_for_new_resource(resource)
      ar = ['new', CrudStar::Engine.config.url_path, resource.to_s.singularize.parameterize, 'path'].delete_if {|i| i.nil? or i.to_s.empty?}
      ar.join('_')
    end
    
    def self.path_for_edit_resource(resource)
      ar = ['edit', CrudStar::Engine.config.url_path, resource.to_s.singularize.parameterize, 'path'].delete_if {|i| i.nil? or i.to_s.empty?}
      ar.join('_')
    end
    
    def self.path_for_resources(resource)
      ar = [CrudStar::Engine.config.url_path, resource.to_s.pluralize.parameterize, 'path'].delete_if {|i| i.nil? or i.to_s.empty?}
      ar.join('_')
    end
    
    # Get a partial name to use. Allows over-riding of default partial by
    # controller. Returns nil if the partial doesn't exist at any point in the hierarchy.
    # 
    # Currently paths checked are:
    # - RAILS_ROOT/app/views/url_path/controller
    # - RAILS_ROOT/app/views/url_path/crud_star_overrides
    # - CRUD_STAR_ROOT/app_views/partial
    def self.get_partial(controller_name, partial)
      filename = "_#{partial}.html.erb"
      base = File.join('app', 'views', CrudStar::Engine.config.url_path)

      paths = []
      paths << [ Rails.root.join(base, controller_name), File.join(controller_name, partial) ]
      paths << [ Rails.root.join(base, 'crud_star_overrides'), File.join('crud_star_overrides', partial) ]
      paths << [ Pathname.new(File.expand_path(File.join('..', '..', '..', 'app', 'views', 'crud_star'), __FILE__)), File.join('crud_star', partial) ]
      
      paths.each do |path|
        return path.last.to_s if path.first.join(filename).exist?
      end
      
      nil
    end
    
    def self.get_template(filename)
      Rails.root.join('app', 'views', CrudStar::Engine.config.url_path, filename + '.html.erb').exist? ? File.join(CrudStar::Engine.config.url_path,filename) : File.join('crud_star', filename)
    end
    
    
    # Displays field help text for a controller action.
    #
    # Looks for a view partial file in the format of
    # '<controller>/_help_<action>.html.erb'.
    #
    # If the file does not exist, nothing is displayed.
    #
    def self.get_action_help(model, action)
      Rails.root.join('app', 'views', CrudStar::Engine.config.url_path, model.name.pluralize.parameterize, '_help_' + action + '.html.erb').exist? ? File.join(CrudStar::Engine.config.url_path, model.name.pluralize.parameterize, 'help_' + action) : nil
    end
    
    def self.get_field(model, attribute)
      Rails.root.join('app', 'views', CrudStar::Engine.config.url_path, model.name.pluralize.parameterize, '_field_' + attribute.gsub(/\./, '_') + '.html.erb').exist? ? File.join(CrudStar::Engine.config.url_path, model.name.pluralize.parameterize, 'field_' + attribute.gsub(/\./, '_')) : nil
    end
    
    def self.get_filter(model, attribute)
      Rails.root.join('app', 'views', CrudStar::Engine.config.url_path, model.name.pluralize.parameterize, '_filter_' + attribute.gsub(/\./, '_') + '.html.erb').exist? ? File.join(CrudStar::Engine.config.url_path, model.name.pluralize.parameterize, 'filter_' + attribute.gsub(/\./, '_')) : nil
    end
    
    # Displays field help text for a specified attribute.
    #
    # Looks for a view partial file in the format of
    # '<controller>/_help_<attribute>.html.erb'.
    #
    # If the file does not exist, nothing is displayed.
    #
    def self.get_field_help(model, attribute)
      Rails.root.join('app', 'views', CrudStar::Engine.config.url_path, model.name.pluralize.parameterize, '_help_' + attribute.gsub(/\./, '_') + '.html.erb').exist? ? File.join(CrudStar::Engine.config.url_path, model.name.pluralize.parameterize, 'help_' + attribute.gsub(/\./, '_')) : nil
    end
    
    # Determines whether the specified attribute is a required field.
    #
    # Creates and validates an empty new object, and checks if there were any
    # errors on the specified field.
    #
    def self.required_field?(model, attribute)
    
      object = model.new
      object.valid?
    
      error = object.errors[attribute.to_sym].empty? ? false : true
      error ||= object.errors[(attribute + '_id').to_sym].empty? ? false : true
    end
    
    
    def self.get_association(model, attribute)
    
      hierarchy = attribute.to_s.split('.')
    
      count = 0
    
      while (count < hierarchy.size) do
      
        if association = model.reflections[hierarchy[count].to_sym]
          model = association.klass
        end
      
        count += 1
      end
    
      association
    end
    
  
  end
end
