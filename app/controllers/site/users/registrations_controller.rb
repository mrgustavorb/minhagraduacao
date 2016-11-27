class Site::Users::RegistrationsController < Devise::RegistrationsController
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_action :store_registration_ip, only: :create
  layout 'site/login'

  private

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit({ user_profile_attributes: [ :scholarity ]  }, :email, :password, :password_confirmation ) }
    end

    def after_inactive_sign_up_path_for(resource)
      new_user_session_path
    end

    def store_registration_ip
      @user.update_attributes({
        registration_ip: request.ip,
        agree_use_term: true
      })
    end

end