class Employees::CustomersController < Employees::ApplicationController 

  before_action :set_graduation_group, only: [:edit, :update]

  add_breadcrumb "Clientes", :employees_customers_path, :only => %w(index new edit create update)
  add_breadcrumb "Novo(a)", :new_employees_customer_path, :only => %w(new create)
  add_breadcrumb "Editar", :edit_employees_customer_path, :only => %w(edit update)

  # http://equipe.minhagraduacao.com/employees/customers
  def index
    @customers = initialize_grid(Customer)
  end

  # http://equipe.minhagraduacao.com/employees/customers/new
  def new
    @customer = Customer.new
    @customer.build_profile
  end

  # http://equipe.minhagraduacao.com/employees/customers
  def create
    @customer      = Customer.new(customer_params)
    @customer.role = :manager

    respond_to do |format|
      if @customer.save

        @customer.save_institutions( params[:customer][:institution_ids] )

        format.html { redirect_to employees_customers_path, notice: t('activerecord.successful.messages.create').html_safe }
      else
        format.html { render action: 'new' }
      end
    end
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

    # def set_graduation_group
    #   @graduation_group = GraduationGroup.find(params[:id])
    #   unless @graduation_group
    #     redirect_to employees_graduation_groups_path
    #   end 
    # end

    def customer_params
      params.require(:customer).permit(:email, :institution_ids, profile_attributes: [:name])
    end

end