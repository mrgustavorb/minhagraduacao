class Employees::InstitutionsController < Employees::ApplicationController 

  before_action :set_institution_group, only: [:edit, :update]

  add_breadcrumb "Instituições", :employees_institutions_path,     :only => %w(index edit update)
  add_breadcrumb "Editar",       :edit_employees_institution_path, :only => %w(edit update)
  
  # http://equipe.minhagraduacao.com/employees/institutions
  def index
    @institutions = initialize_grid(Institution)
  end

  # http://equipe.minhagraduacao.com/employees/institutions/:id/edit
  def edit; end

  # http://equipe.minhagraduacao.com/employees/institutions/:id
  def update; 
    respond_to do |format|
      if @institutions.update(institution_params)
        format.html { redirect_to edit_employees_institutions_path(@institutions), notice: t('activerecord.successful.messages.update').html_safe }
      else
        flash[:alert] = t('activerecord.successful.messages.error').html_safe
        format.html { render action: 'edit' }
      end
    end
  end

  private

    def set_institution_group
      @institutions = Institutions.find(params[:id])
      unless @institutions
        redirect_to employees_institutions_path
      end 
    end

    def institution_params
      params.require(:institution).permit(:name)
    end

end