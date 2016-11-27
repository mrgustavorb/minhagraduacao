class Site::ApplicationController < ActionController::Base
  
  after_filter :store_location

  layout :layout_by_resource

  private
  
    # Code from https://github.com/plataformatec/devise/wiki/How-To:-Redirect-back-to-current-page-after-sign-in,-sign-out,-sign-up,-update
    def store_location
      # store last url - this is needed for post-login redirect to whatever the user last visited.
      return unless request.get? 
      if (request.path != "/users/sign_in" &&
          request.path != "/users/sign_up" &&
          request.path != "/users/password/new" &&
          request.path != "/users/password/edit" &&
          request.path != "/users/confirmation" &&
          request.path != "/users/sign_out" &&
          !request.xhr?) # don't store ajax calls
        session[:previous_url] = request.fullpath 
      end
    end

    def layout_by_resource
      if devise_controller?
        if resource_name == :user
          "site/login"
        else
          "backend/login"
        end
      else
        "site/application"
      end
    end

    def last_seen_at
      
    end

    def after_sign_in_path_for(resource)
      page = root_path

      if resource_name == :user
        page = which_user_research? 
      end 
      if resource_name == :employee
        page = root_employee_path 
      end 
      if resource_name == :customer
        page = root_customer_path 
      end 

      page
    end

    def user_answered_research?
      if !signed_in? || (signed_in? && current_user.answered)   
        redirect_to root_path
      elsif signed_in? && current_user.user_profile.scholarity == 0
        redirect_to choice_scholarity_path      
      end 
    end

    def which_user_research?
      page = root_path
      if signed_in? && !current_user.answered
        page = case current_user.user_profile.scholarity
          when 0
            choice_scholarity_path          
          when 1
            students_research_path
          when 2
            academics_research_path
          when 3
            professionals_research_path
        end
      elsif signed_in? && current_user.answered
        page = session[:previous_url] || root_path
      end

      page
    end

end