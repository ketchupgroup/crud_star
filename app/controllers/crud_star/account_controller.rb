module CrudStar
  class AccountController < CrudStar::AdminController
  
    layout false
  
    def login
    
      flash[:errors] = []
    
      if request.post?
      
        if @user = User.authenticate(params[:user], params[:password])
          if @user.disabled
            flash[:errors] << "Your account has been disabled. Please contact a manager to reenable it."
            render :login and return
          end
          
          @user.failed_logins = 0
          @user.save
          
          session[:crud_star][:user]  = @user.id
          session[:crud_star][:role]  = :admin
        
          
          unless session[:crud_star][:requested_page].nil?
          
            redirect_to session[:crud_star][:requested_page]
          else
            redirect_to :controller => '/crud_star/index'
          end
        else
          if user = User.find_by_username(params[:user])
            
            if user.disabled
              flash[:errors] << "Your account has been disabled. Please contact a manager to reenable it."
            else
              flash[:errors] << 'User name or password invalid.'
            end
            
            user.failed_logins += 1
            if user.failed_logins == 3
              user.disabled = true
            end
            user.save
          end
        end
      end
    
    end
  
  
    def logout
      reset_session
      redirect_to :controller => '/crud_star/index'
    end
  end
end
