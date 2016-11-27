# Customers
# ------------------------------------------------------------------------------------------
class Backend::Customers::SemestersController < Backend::Customers::ApplicationController 

  before_action :set_graduation_profile, only: [:new, :create, :edit, :update]
  before_action :set_semester, only: [:edit, :update]
  before_action :set_breadcrumb, only: [:new, :edit, :graduations]

  def new

    add_breadcrumb "Novo Semestre"

    @semester = Semester.new
  end

  def create
    count_semesters = Semester.select('(count(1)+1) as next').find_by(graduation_profile_id: @graduation_profile.id)
    @semester = Semester.new({:graduation_profile_id => @graduation_profile.id, :number_semester => count_semesters.next})

    respond_to do |format|
      if @semester.save

        save_disciplines!

        format.html { redirect_to customers_edit_semester_path(@graduation_profile, @semester), notice: 'Successfully created.' }
      else
        format.html { render action: 'new' }
        format.json { render json: @semester.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit

    add_breadcrumb @graduation_profile.connection.institution.sigla, edit_customers_institution_path(@graduation_profile.connection.institution_id)
    add_breadcrumb @graduation_profile.connection.graduation.name, customers_edit_graduation_profile_path(@graduation_profile.graduation_institution_id)
    add_breadcrumb "Editar #{ @semester.number_semester }˚ semestre"

  end

  def update
    respond_to do |format|

      Discipline.where(:semester_id => @semester.id).destroy_all

      save_disciplines!

      format.html { redirect_to customers_edit_semester_path(@graduation_profile, @semester), notice: 'Successfully updated.' }
      format.json { head :no_content }
    end    
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    # -------------------------------------------------------------------
    def set_graduation_profile
      @graduation_profile = GraduationProfile.find_by(id: params[:graduation_profile_id])

      begin
        unless current_customer.institutions.find_by(id: @graduation_profile.connection.institution_id).graduations.find_by(id: @graduation_profile.connection.graduation_id)
          raise "error"
        end    
      rescue => ex
        redirect_to root_customer_path
      end 
    end     

    def set_semester
      @semester = Semester.find(params[:semester_id])
    end    

    def set_breadcrumb
      if current_customer.institutions.count > 1 
        add_breadcrumb "Instituições", :customers_institutions_path
      end

      add_breadcrumb @graduation_profile.connection.institution.name, edit_customers_institution_path(@graduation_profile.connection.institution_id)
      add_breadcrumb "Graduações", graduations_customers_institution_path(@graduation_profile.connection.institution_id)
      add_breadcrumb @graduation_profile.connection.graduation.name, edit_graduation_profile_path(@graduation_profile.id)
    end

    def save_disciplines!
      i = 0
      params[:disciplines][:name].each do |discipline|

        Discipline.new({:semester_id => @semester.id, :name => discipline}).save!
        # Discipline.new({:semester_id => @semester.id, :name => discipline, :hours => params[:disciplines][:hours][i]}).save!
        
        i += 1
      end
    end

end
