class Employees::SchoolsController < Employees::ApplicationController 

	before_action :set_school_group, only: [:edit, :update]

	add_breadcrumb "Escolas", :employees_schools_path,    :only => %w(index edit update)
	add_breadcrumb "Editar",  :edit_employees_school_path, :only => %w(edit update)

  # http://equipe.minhagraduacao.com/employees/schools
  def index
    @schools = initialize_grid(School)
  end

  # http://equipe.minhagraduacao.com/employees/schools/:id
	def edit; end

  # http://equipe.minhagraduacao.com/employees/schools/:id
  def update; 
    respond_to do |format|
      if @school.update(school_params)
        format.html { redirect_to edit_employees_school_path(@school), notice: t('activerecord.successful.messages.update').html_safe }
      else
        flash[:alert] = t('activerecord.successful.messages.error').html_safe
        format.html { render action: 'edit' }
      end
    end
  end

  private

    def set_school_group
      @schools = Schools.find(params[:id])
      unless @schools
        redirect_to employees_schools_path
      end
    end

    def school_params
      params.require(:school).permit(:name)
    end

end