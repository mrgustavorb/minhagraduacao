class Employees::ApplicationController < ApplicationController

  before_action :authenticate_employee!

  layout "backend/application"

  add_breadcrumb "Dashboard", :root_employee_path
  
end
