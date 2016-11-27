class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_name}.rb")))
  end
end

Minhagraduacao::Application.routes.draw do
# routes to subdomain equipe.minhgraduacao.com
  # ================================================
  constraints subdomain: 'equipe' do
    devise_for :employees

    # equipe.minhgraduacao.com/employees/*
    # ==============================================
    namespace :employees do
      resources :customers
      resources :graduation_groups
      resources :institutions
      resources :schools
      resources :users
      resources :reports
    end  

    unauthenticated :employee do
      devise_scope :employee do
        root to: 'devise/sessions#new', :as => 'employee_unauthenticated'
      end
    end

    get '/' => 'employees/dashboard#index', as: :root_employee
  end

  # routes to subdomain cliente.minhagraduacao.com
  # ================================================
  constraints subdomain: 'cliente' do

    devise_for :customer, :controllers => { 
      :confirmations => "backend/customers/confirmations",
    }

    # equipe.minhgraduacao.com/customers/*
    # ==============================================
    scope module: 'backend' do
      namespace :customers do
        resources :institutions do
          get :graduations, :on => :member 
        end

        # Graduation Profiles
        get   'graduation/profile/:graduation_institution_id/edit'   => 'graduation_profiles#edit', as: :edit_graduation_profile
        patch 'graduation/profile/:graduation_institution_id/update' => 'graduation_profiles#update'
        post  'graduation/profile/:graduation_institution_id/update' => 'graduation_profiles#update'        

        # Semesters
        get   'semester/:graduation_profile_id/new'                 => 'semesters#new',    as: :semesters
        post  'semester/:graduation_profile_id/new'                 => 'semesters#create', as: :semester
        get   'semester/:graduation_profile_id/:semester_id/edit'   => 'semesters#edit',   as: :edit_semester
        patch 'semester/:graduation_profile_id/:semester_id/update' => 'semesters#update'
        post  'semester/:graduation_profile_id/:semester_id/update' => 'semesters#update'
        
        # Photos
        post 'institution/photos/:institution_id/upload' => 'institution_photos#upload', as: :institution_photo
      end  
    end  

    as :customer do
      patch '/customers/confirmation' => 'backend/customers/confirmations#update', :via => :patch, :as => :update_customer_confirmation
    end

    unauthenticated :customer do
      devise_scope :customer do
        root to: 'devise/sessions#new', :as => 'customer_unauthenticated'
      end
    end

    get '/' => 'backend/customers/dashboard#index', as: :root_customer
  end

  # routes to minhagraduacao.com
  # ================================================
  draw :site
end
