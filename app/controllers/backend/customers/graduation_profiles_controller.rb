# Customers
# ------------------------------------------------------------------------------------------
class Backend::Customers::GraduationProfilesController < Backend::Customers::ApplicationController

  before_action :set_graduation_profile, only: [:edit, :update]
  before_action :set_breadcrumb, only: [:edit]

  def edit; end

  def update
    @graduation_profile.update(graduation_profile_params)
    respond_to do |format|
      if @graduation_profile.update(graduation_profile_params)
        format.html { redirect_to customers_edit_graduation_profile_path(params[:graduation_institution_id]), notice: 'Successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @graduation_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def set_graduation_profile
      @graduation_profile = GraduationProfile.find_by(graduation_institution_id: params[:graduation_institution_id])

      if @graduation_profile.nil?
        @graduation_profile = GraduationProfile.new({:graduation_institution_id => params[:graduation_institution_id]})
      end    

      begin
        unless current_customer.institutions.find_by(id: @graduation_profile.connection.institution_id).graduations.find_by(id: @graduation_profile.connection.graduation_id)
          raise "error"
        end    
      rescue => ex
        redirect_to root_customer_path
      end 
    end    

    def set_breadcrumb
      if current_customer.institutions.count > 1 
        add_breadcrumb "Instituições", :customers_institutions_path
      end

      add_breadcrumb @graduation_profile.connection.institution.name, edit_customers_institution_path(@graduation_profile.connection.institution_id)
      add_breadcrumb "Graduações", graduations_customers_institution_path(@graduation_profile.connection.institution_id)
      add_breadcrumb @graduation_profile.connection.graduation.name
    end

    def graduation_profile_params
      params.require(:graduation_profile).permit(:description, :coordination, :period, :hours, :monthly_payment, :video_link)
    end  
end