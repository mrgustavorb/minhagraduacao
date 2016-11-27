# Customers
# ------------------------------------------------------------------------------------------
class Backend::Customers::InstitutionsController < Backend::Customers::ApplicationController 

  before_action :set_institution, only: [:edit, :update, :graduations]
  before_action :set_breadcrumb, only: [:edit, :graduations]

  # http://cliente.minhagraduacao.com/customers/institutions
  def index
    @institutions = current_customer.institutions.order(:sigla, :name)
  end

  # http://cliente.minhagraduacao.com/customers/institutions/:id/edit
  def edit
    add_breadcrumb "Informações", edit_customers_institution_path
  end

  # http://cliente.minhagraduacao.com/customers/institutions/:id/graduations
  def graduations
    add_breadcrumb "Graduações", graduations_customers_institution_path
    render 'edit'
  end

  # http://cliente.minhagraduacao.com/customers/institutions/:id
  def update
    respond_to do |format|
      if @institution.update(institution_params)
        format.html { redirect_to edit_customers_institution_path(@institution), notice: 'Successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end
    
  private

    def set_institution
      @institution = current_customer.institutions.find_by(id: params[:id])
      unless @institution
        redirect_to root_customer_path
      end 
    end

    def set_breadcrumb
      if current_customer.institutions.count > 1 
        add_breadcrumb "Instituições", :customers_institutions_path
      end

      add_breadcrumb @institution.name, edit_customers_institution_path(@institution.id)
    end

    def institution_params
      params.require(:institution).permit(:name, :sigla, institution_profile_attributes: [:avatar, :igc, :accepts_fies, :accepts_prouni, :total_professors_phd, :total_professors_master, :total_professors_graduatos])
    end

end