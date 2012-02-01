# Filters and methods applied to the controller will affect the entire admin
# control panel.
#
module CrudStar
  class AdminController < ApplicationController
  
    # Use ActiveRecord as the session store for the admin area so we can store
    # objects which are being edited. The cookie store is limited to 4KB. Change
    # the session key to separate from the main site.
    #session :database_manager => CGI::Session::ActiveRecordStore,
    #        :session_key => 'fairline_rsvp_admin_session_id'
  
    layout 'crud_star'
  
    # Hide these controller methods so they are not as accessible as actions.
    # Cannot set as protected or private due to inheritance and view dependance.
    hide_action ['sidebar_actions', 'permissions', 'model', 'model_name' ]
    
    helper_method :current_user, :user_has_permission?, :sidebar_actions_for_user
    
    before_filter :init
  
    def sidebar_actions
      {:admin => {}}
    end
    
    def sidebar_actions_for_user(type)
      actions = sidebar_actions[current_user.role]
      return [] if actions.nil?
      sidebar_actions[current_user.role][type] || []
    end

    def permissions
      {:admin => []}
    end

    def model
      controller_name.singularize.camelize.constantize
    end
      
    def model_name
      model.model_name.human
    end
  
    # Internal utility methods.
    protected
    
      def init
        session[:crud_star] ||= {}
        @subnav = nil
      end
    
      def validate_login
        if current_user.nil?
          session[:crud_star][:requested_page] = params
          session[:crud_star][:requested_page][:controller] = '/' + session[:crud_star][:requested_page][:controller]
          
          redirect_to :controller => 'crud_star/account', :action => 'login'
        else
          session[:crud_star][:requested_page] = nil
        end
      end
    
      def validate_access
        unless check_permissions
          redirect_to :controller => 'crud_star/index', :action => 'index'
        end
      end
      
      def current_user
        unless session.nil? || session[:crud_star].nil? or session[:crud_star][:user].blank?
          User.find(session[:crud_star][:user])
        end
      end
      
      def user_has_permission?(action)
        if CrudStar::Engine.config.use_cancan
          check_permission_from_cancan(action)
        else
          check_permission_from_controller(action)
        end
      end

      def check_permissions
        user_has_permission?(action_name)
      end

      def check_permission_from_cancan(action)
        CrudStar::Engine.config.ability_class.new(current_user).can?(action.to_sym, model)
      end

      def check_permission_from_controller(action)
        perms = permissions
        unless perms.nil?
          unless perms[session[:crud_star][:role].to_sym].nil?
            return perms[session[:crud_star][:role].to_sym].include?(action)
          end
          raise RuntimeError.new("You need to define #{session[:crud_star][:role]} permissions for #{action}")
        end
        raise RuntimeError.new("You need to define permissions for #{action}")
      end
  end
end
