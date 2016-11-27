# routes to subdomain equipe.minhgraduacao.com
# ================================================
constraints subdomain: 'equipe' do
  devise_for :employees

  unauthenticated :employee do
    devise_scope :employee do
      root to: 'employees/sessions#new', :as => 'employee_unauthenticated'
    end
  end

  get '/' => 'employees/dashboard#index', as: :root_employee
end