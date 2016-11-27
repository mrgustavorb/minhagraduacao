# routes to subdomain escola.agendakidsdigital.com
# ================================================
constraints subdomain: 'cliente' do
  devise_for :customers, :controllers => { :confirmations => "schools/confirmations" }
 
 
 
  get '/' => 'schools/dashboard#index', as: :root_school
end