class Employees::GraduationGroupsController < Employees::ApplicationController 

  before_action :set_graduation_group, only: [:edit, :update]

  add_breadcrumb "Graduações", :employees_graduation_groups_path,     :only => %w(index edit update)
  add_breadcrumb "Editar",     :edit_employees_graduation_group_path, :only => %w(edit update)

  # http://equipe.minhagraduacao.com/employees/graduation_groups
  def index
    @graduation_groups = initialize_grid(GraduationGroup)
  end

  # http://equipe.minhagraduacao.com/employees/graduation_groups/:id/edit
  def edit; end

  # http://equipe.minhagraduacao.com/employees/graduation_groups/:id
  def update; 
    respond_to do |format|
      if @graduation_group.update(graduation_group_params)
        format.html { redirect_to edit_employees_graduation_group_path(@graduation_group), notice: t('activerecord.successful.messages.update').html_safe }
      else
        flash[:alert] = t('activerecord.successful.messages.error').html_safe
        format.html { render action: 'edit' }
      end
    end
  end
    
  private

    def set_graduation_group
      @graduation_group = GraduationGroup.find(params[:id])
      unless @graduation_group
        redirect_to employees_graduation_groups_path
      end 
    end

    def graduation_group_params
      params.require(:graduation_group).permit(:name, :description, :source)
    end

end