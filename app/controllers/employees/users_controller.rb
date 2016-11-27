class Employees::UsersController < Employees::ApplicationController
	before_action :set_user, only: [:edit, :update]

	add_breadcrumb "Usuários", :employees_users_path, :only => %w(index)

	# http://equipe.minhagraduacao.com/employees/users
  def index
    @users = initialize_grid(User.order("answered DESC"))
  end

  private

    def set_user
      @user = User.find(params[:id])
      unless @user
        redirect_to employees_users_path
      end 
    end

    def user_params
      params.require(:user).permit(:name)
    end

end