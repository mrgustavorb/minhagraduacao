class Site::Users::ProfilesController < Site::ApplicationController

  before_filter :authenticate_user!, only: [:edit, :update]

  def edit
    current_user.user_profile ||= UserProfile.new
    @profile = current_user.user_profile
    render layout: 'site/login'
  end

  def update
    current_user.user_profile.update_attributes! profile_params
    redirect_to action: :edit
  end

  private

    def profile_params
      params.require(:user_profile).permit(:name, :birthday, :gender)
    end

end