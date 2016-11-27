class Site::Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?

      unless @user.registration_ip?
        @user.update_attributes({
          registration_ip: request.ip,
          agree_use_term: true
        })
        UserMailer.sign_up_facebook(@user).deliver
      end

      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      flash[:alert] = 'Dica: Experimente definir o seu endereço de e-mail primário em sua conta do Facebook'
      redirect_to new_user_registration_url
    end
  end
end