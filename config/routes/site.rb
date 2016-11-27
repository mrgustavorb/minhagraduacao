  # routes to minhagraduacao.com
  # ================================================
  # Authentication for user
  devise_for :users, controllers: {
    omniauth_callbacks: 'site/users/omniauth_callbacks',
    passwords: 'site/users/passwords',
    registrations: 'site/users/registrations',
    sessions: 'site/users/sessions'  
  }

  scope module: 'site' do 
    
    # Pages
    get  'contato'          => 'pages#contact',                as: :contact_us
    post 'contato'          => 'pages#contact_send'
    get  'termo-de-uso'     => 'pages#term_of_use',            as: :term_of_use
    get  'escolaridade'     => 'pages#choice_scholarity',      as: :choice_scholarity
    get  'escolaridade/:id' => 'pages#choice_scholarity_save', as: :choice_scholarity_save, id: /1|2|3/

    # Cities
    get  'cities/find_by_uf/:uf_id/:graduation_id' => 'cities#find_by_uf'

    # Schools
    get  'schools/:uf_id/find_by_uf/'            => 'schools#find_by_uf'
    get  'schools/:uf_id/:city_id/find_by_city/' => 'schools#find_by_city'
     
    # Users
    get   'meus-videos' => 'users#my_videos'
    get   'profile'     => 'users/profiles#edit'
    patch 'profile'     => 'users/profiles#update'

    # Search
    get  'search/suggest'            => 'search#search_suggest'
    get  'search/schools/suggest'    => 'search#search_school_suggest'
    get  'search/graduations/tag'    => 'search#search_graduations_tag'
    get  'search/institutions/tag'   => 'search#search_institutions_tag'
    get  'pesquisar(/:url_friendly)' => 'search#search',                    as: :search

    # Formulários de pesquia
    get  'pesquisa_aluno'            => 'researchs/students#research',      as: :students_research
    post 'pesquisa_aluno'            => 'researchs/students#save',          as: :students_research_save
    get  'pesquisa_universitario'    => 'researchs/academics#research',     as: :academics_research
    post 'pesquisa_universitario'    => 'researchs/academics#save',         as: :academics_research_save
    get  'pesquisa_profissional'     => 'researchs/professionals#research', as: :professionals_research
    post 'pesquisa_profissional'     => 'researchs/professionals#save',     as: :professionals_research_save

    # Institutions
    get  'institutions/:uf_id'                                                                      => 'institutions#get_institutions'
    get  'institutions/ufs/:graduation_id'                                                          => 'institutions#ufs'
    get  'institutions/where_to_study/:method_teaching_id/:graduation_id'                           => 'institutions#where_to_study'

    get  'institutions/where_to_study_in_a_state/:uf_id/:graduation_id'                             => 'institutions#where_to_study_in_a_state'
    get  'institutions/where_to_study_in_a_city/:city_id/:graduation_id'                            => 'institutions#where_to_study_in_a_city'
    get  'instituicao/:url_friendly_institution/:institution_id'                                    => 'institutions#show',                     as: :institution_show_perfil
    get  'instituicao/:url_friendly_institution/graduacao/:url_friendly_graduation/:institution_id' => 'institutions#show',                     as: :institution_show
    get  'cliente/demo'                                                                             => 'institutions#demo'

    # Graduations
    get 'graduations/:institution_id'                                         => 'graduations#get_graduations'
    get 'graduacoes'                                                          => 'graduations#list',           as: :graduations
    get 'graduacao/:url_friendly'                                             => 'graduations#about',          as: :graduation_about
    get 'graduacao/:url_friendly/avaliacoes'                                  => 'graduations#evaluations',    as: :graduation_evaluations
    get 'graduacao/:url_friendly/instituicoes'                                => 'graduations#institutions',   as: :graduation_institutions


    # Home
    root "pages#index"
  end