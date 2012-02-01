module CrudStar
  class Engine < Rails::Engine

    config.application_name = 'CrudStar'
    config.url_path         = 'admin'
    config.theme            = 'green'
    
    # Define the navigation layers of the control panel.
    #
    # This method should return a multi-dimensional array. The first dimension of
    # the array defines the primary tabs. Each array member is itself an array
    # containing the following elements:
    #
    # * Display label
    # * URL to link to
    # * Array of secondary navigation links (optional)
    #
    # The secondary navigation links element can be an array containing the label
    # and URL only. If none are supplied the secondary navigation will not be
    # displayed.
    #
    config.navigation = :dashboard
    
    # Register additional JavaScripts to use
    ActionView::Helpers::AssetTagHelper.register_javascript_expansion :crud_star_app => []
    
  end
end
