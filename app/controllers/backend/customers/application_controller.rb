# Customers
# ------------------------------------------------------------------------------------------
class Backend::Customers::ApplicationController < ApplicationController
  before_action :authenticate_customer!

  layout "backend/application"

  add_breadcrumb "Dashboard", :root_customer_path
end
