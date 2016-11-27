class CreateInitialSchema < ActiveRecord::Migration
  def up
    # Creating previous tables
    
   if !ActiveRecord::Base.connection.table_exists? 'academic_degrees'
      create_table "academic_degrees", force: true do |t|
        t.string   "name"
        t.datetime "created_at"
        t.datetime "updated_at"
      end
    end  

    if !ActiveRecord::Base.connection.table_exists? 'academic_organizations'
      create_table "academic_organizations", force: true do |t|
        t.integer  "co_organizacao_academica"
        t.string   "name"
        t.string   "url_friendly"
        t.datetime "created_at"
        t.datetime "updated_at"
      end
    end

    if !ActiveRecord::Base.connection.table_exists? 'cities'
      create_table "cities", force: true do |t|
        t.integer  "uf_id"
        t.integer  "co_municipio"
        t.string   "name",         limit: 100
        t.integer  "is_capital"
        t.datetime "created_at"
        t.datetime "updated_at"
      end  
      add_index "cities", ["co_municipio"], name: "idx_cities_co_municipio", using: :btree
      add_index "cities", ["uf_id"], name: "idx_cities", using: :btree
    end

    if !ActiveRecord::Base.connection.table_exists? 'cities_institutions'
      create_table "cities_institutions", force: true do |t|
        t.integer "city_id"
        t.integer "institution_id"
      end

      add_index "cities_institutions", ["city_id"], name: "idx_graduations_institutions_2", using: :btree
      add_index "cities_institutions", ["institution_id"], name: "idx_graduations_institutions_1", using: :btree
    end

    if !ActiveRecord::Base.connection.table_exists? 'customer_profiles'
      create_table "customer_profiles", force: true do |t|
        t.integer  "customer_id",         null: false
        t.string   "name"
        t.string   "avatar_file_name"
        t.string   "avatar_content_type"
        t.integer  "avatar_file_size"
        t.datetime "avatar_updated_at"
        t.datetime "created_at"
        t.datetime "updated_at"
        t.datetime "deleted_at"
      end

      add_index "customer_profiles", ["customer_id"], name: "idx_customer_profiles", using: :btree
    end 
     
    if !ActiveRecord::Base.connection.table_exists? 'customers'
      create_table "customers", force: true do |t|
        t.string   "role",                   limit: 100
        t.string   "email",                              default: "", null: false
        t.string   "encrypted_password",                 default: "", null: false
        t.string   "reset_password_token"
        t.datetime "reset_password_sent_at"
        t.datetime "remember_created_at"
        t.integer  "sign_in_count",                      default: 0,  null: false
        t.datetime "current_sign_in_at"
        t.datetime "last_sign_in_at"
        t.string   "current_sign_in_ip"
        t.string   "last_sign_in_ip"
        t.string   "confirmation_token"
        t.datetime "confirmed_at"
        t.datetime "confirmation_sent_at"
        t.string   "unconfirmed_email"
        t.boolean  "status"
        t.datetime "created_at"
        t.datetime "updated_at"
        t.datetime "deleted_at"
      end

      add_index "customers", ["confirmation_token"], name: "index_school_users_on_confirmation_token", unique: true, using: :btree
      add_index "customers", ["email"], name: "index_clients_on_email", unique: true, using: :btree
      add_index "customers", ["reset_password_token"], name: "index_clients_on_reset_password_token", unique: true, using: :btree
    end 
      
    if !ActiveRecord::Base.connection.table_exists? 'disciplines'
      create_table "disciplines", force: true do |t|
        t.integer "semester_id"
        t.string  "name",        limit: 100
        t.integer "hours"
      end

      add_index "disciplines", ["semester_id"], name: "idx_disciplines", using: :btree
    end 
     
    if !ActiveRecord::Base.connection.table_exists? 'employee_profiles'
      create_table "employee_profiles", force: true do |t|
        t.integer  "employee_id"
        t.string   "name"
        t.text     "bios"
        t.text     "picture"
        t.datetime "created_at"
        t.datetime "updated_at"
      end

      add_index "employee_profiles", ["employee_id"], name: "idx_employee_profiles", using: :btree
    end 
      
    if !ActiveRecord::Base.connection.table_exists? 'employees'
      create_table "employees", force: true do |t|
        t.string   "email",                  default: "", null: false
        t.string   "encrypted_password",     default: "", null: false
        t.string   "reset_password_token"
        t.datetime "reset_password_sent_at"
        t.datetime "remember_created_at"
        t.integer  "sign_in_count",          default: 0,  null: false
        t.datetime "current_sign_in_at"
        t.datetime "last_sign_in_at"
        t.string   "current_sign_in_ip"
        t.string   "last_sign_in_ip"
      end
    end 

    if !ActiveRecord::Base.connection.table_exists? 'evaluation_graduations'
      create_table "evaluation_graduations", force: true do |t|
        t.integer  "graduation_group_id"
        t.integer  "user_id"
        t.integer  "graduation_professional"
        t.integer  "social_recognition"
        t.integer  "graduation_difficulty"
        t.integer  "renumbered_training"
        t.integer  "first_job"
        t.integer  "job_most_areas"
        t.integer  "tendering"
        t.integer  "starting_salary"
        t.integer  "professional_salary"
        t.text     "advantage"
        t.text     "disadvantage"
        t.integer  "recommendation"
        t.datetime "created_at"
        t.datetime "updated_at"
      end

      add_index "evaluation_graduations", ["graduation_group_id"], name: "idx_evaluation_graduation", using: :btree
      add_index "evaluation_graduations", ["user_id"], name: "idx_evaluation_graduation_0", using: :btree
    end
      
    if !ActiveRecord::Base.connection.table_exists? 'evaluation_institutions'
      create_table "evaluation_institutions", force: true do |t|
        t.integer  "user_id"
        t.integer  "accreditation"
        t.integer  "website_academic"
        t.integer  "level_students"
        t.integer  "money"
        t.integer  "student_organizations"
        t.integer  "sector_stage"
        t.integer  "security"
        t.integer  "infrastructure"
        t.integer  "academic_exchange"
        t.datetime "created_at"
        t.datetime "updated_at"
        t.integer  "professor"
        t.integer  "coordinator"
        t.integer  "pratical_activities"
        t.integer  "extra_activities"
        t.integer  "sports_activities"
        t.text     "advantage"
        t.text     "disadvantage"
        t.integer  "recommendation"
        t.integer  "institution_id"
      end

      add_index "evaluation_institutions", ["user_id"], name: "idx_student_evaluation_institutions", using: :btree
    end
  
    if !ActiveRecord::Base.connection.table_exists? 'evaluation_schools'
      create_table "evaluation_schools", force: true do |t|
        t.integer  "school_id"
        t.integer  "user_id"
        t.integer  "security"
        t.integer  "teachers"
        t.integer  "coordinator"
        t.integer  "laboratory"
        t.integer  "classmates"
        t.integer  "methodology"
        t.integer  "extra_activities"
        t.integer  "sports_activities"
        t.integer  "recommendation"
        t.datetime "created_at"
        t.datetime "updated_at"
        t.integer  "physical_structure"
      end

      add_index "evaluation_schools", ["school_id"], name: "idx_school_evaluations", using: :btree
    end  

    if !ActiveRecord::Base.connection.table_exists? 'favorite_graduations'
      create_table "favorite_graduations", force: true do |t|
        t.integer  "user_id"
        t.integer  "graduation_group_id"
        t.datetime "created_at"
        t.datetime "updated_at"
      end

      add_index "favorite_graduations", ["user_id"], name: "index_user_profiles_on_user_id_0", using: :btree
    end
      
    if !ActiveRecord::Base.connection.table_exists? 'favorite_institutions'
      create_table "favorite_institutions", force: true do |t|
        t.integer  "user_id"
        t.integer  "institution_id"
        t.datetime "created_at"
        t.datetime "updated_at"
      end

      add_index "favorite_institutions", ["user_id"], name: "index_user_profiles_on_user_id_1", using: :btree
    end
      
    if !ActiveRecord::Base.connection.table_exists? 'graduation_groups'
      create_table "graduation_groups", force: true do |t|
        t.string   "name"
        t.string   "name_noaccent"
        t.string   "url_friendly"
        t.boolean  "active"
        t.datetime "created_at"
        t.datetime "updated_at"
        t.decimal  "views",         precision: 20, scale: 0
        t.text     "json_data"
        t.text     "description"
        t.string   "source"
      end

      add_index "graduation_groups", ["name_noaccent"], name: "idx_graduation_groups_name_noaccent", using: :btree
    end
      
    if !ActiveRecord::Base.connection.table_exists? 'graduation_profiles'
      create_table "graduation_profiles", force: true do |t|
        t.integer "graduation_institution_id"
        t.text    "description"
        t.text    "coordination"
        t.string  "period",                    limit: 100
        t.text    "hours"
        t.string  "monthly_payment",           limit: 100
        t.string  "video_link"
      end

      add_index "graduation_profiles", ["graduation_institution_id"], name: "idx_graduation_profiles", using: :btree
    end  
    
    if !ActiveRecord::Base.connection.table_exists? 'graduations'
      create_table "graduations", force: true do |t|
        t.string   "name",                limit: 200
        t.string   "name_noaccent",       limit: 200
        t.string   "url_friendly",        limit: 200
        t.boolean  "active"
        t.datetime "updated_at"
        t.datetime "created_at"
        t.string   "no_curso",            limit: 200
        t.string   "load_code",           limit: 100
        t.integer  "graduation_group_id"
      end

      add_index "graduations", ["graduation_group_id"], name: "idx_graduations", using: :btree
    end  
    
    if !ActiveRecord::Base.connection.table_exists? 'graduations_institutions'
      create_table "graduations_institutions", force: true do |t|
        t.integer "institution_id"
        t.integer "graduation_id"
        t.integer "co_curso"
        t.integer "academic_degree_id"
        t.integer "method_teaching_id"
      end

      add_index "graduations_institutions", ["academic_degree_id"], name: "idx_graduations_institutions_3", using: :btree
      add_index "graduations_institutions", ["graduation_id"], name: "idx_graduations_institutions", using: :btree
      add_index "graduations_institutions", ["institution_id"], name: "idx_graduations_institutions_0", using: :btree
      add_index "graduations_institutions", ["method_teaching_id"], name: "idx_graduations_institutions_4", using: :btree
    end
      
    if !ActiveRecord::Base.connection.table_exists? 'institution_photos'
      create_table "institution_photos", force: true do |t|
        t.integer  "institution_id"
        t.datetime "created_at"
        t.datetime "updated_at"
        t.string   "photo_file_name"
        t.string   "photo_content_type"
        t.integer  "photo_file_size"
        t.datetime "photo_updated_at"
      end

      add_index "institution_photos", ["institution_id"], name: "idx_institution_profiles_0", using: :btree
    end
    
    if !ActiveRecord::Base.connection.table_exists? 'institution_profiles'
      create_table "institution_profiles", force: true do |t|
        t.integer  "institution_id"
        t.text     "description"
        t.integer  "igc",                                   default: 0
        t.boolean  "accepts_fies",                          default: false
        t.boolean  "accepts_prouni",                        default: false
        t.integer  "total_professors_phd",                  default: 0
        t.integer  "total_professors_master",               default: 0
        t.integer  "total_professors_graduatos",            default: 0
        t.string   "site"
        t.string   "video_link"
        t.text     "email"
        t.string   "phone"
        t.string   "address"
        t.string   "url_facebook"
        t.string   "url_twitter"
        t.string   "url_youtube"
        t.string   "url_instagram"
        t.string   "url_google_plus"
        t.string   "avatar_file_name"
        t.string   "avatar_content_type"
        t.integer  "avatar_file_size"
        t.datetime "avatar_updated_at"
        t.datetime "created_at"
        t.datetime "updated_at"
        t.string   "cep",                        limit: 50
      end

      add_index "institution_profiles", ["institution_id"], name: "idx_institution_profiles", using: :btree
    end  

    if !ActiveRecord::Base.connection.table_exists? 'institutions'
      create_table "institutions", force: true do |t|
        t.string   "name"
        t.datetime "created_at"
        t.datetime "updated_at"
        t.integer  "co_ies"
        t.integer  "co_mantenedora"
        t.boolean  "active"
        t.string   "load_code",                limit: 100
        t.string   "no_ies",                   limit: 200
        t.string   "name_noaccent",            limit: 200
        t.string   "url_friendly",             limit: 200
        t.string   "sigla",                    limit: 100
        t.integer  "uf_id"
        t.integer  "customer_id"
        t.integer  "academic_organization_id"
      end

      add_index "institutions", ["academic_organization_id"], name: "idx_institutions_0", using: :btree
      add_index "institutions", ["customer_id"], name: "idx_institutions_1", using: :btree
      add_index "institutions", ["uf_id"], name: "idx_institutions", using: :btree
    end

    if !ActiveRecord::Base.connection.table_exists? 'method_teachings'
      create_table "method_teachings", force: true do |t|
        t.string   "name"
        t.datetime "created_at"
        t.datetime "updated_at"
      end
    end
  
    if !ActiveRecord::Base.connection.table_exists? 'pg_search_documents'
      create_table "pg_search_documents", force: true do |t|
        t.text     "content"
        t.integer  "searchable_id"
        t.string   "searchable_type"
        t.datetime "created_at"
        t.datetime "updated_at"
      end
    end
  
    if !ActiveRecord::Base.connection.table_exists? 'posts'
      create_table "posts", force: true do |t|
        t.string   "title"
        t.text     "content"
        t.string   "url_friendly"
        t.datetime "created_at"
        t.datetime "updated_at"
      end
    end
      
    if !ActiveRecord::Base.connection.table_exists? 'regions'
      create_table "regions", force: true do |t|
        t.string   "name",       limit: 100
        t.string   "region"
        t.datetime "created_at"
        t.datetime "updated_at"
      end
    end
      
    if !ActiveRecord::Base.connection.table_exists? 'schools'
      create_table "schools", force: true do |t|
        t.integer  "uf_id"
        t.integer  "city_id"
        t.string   "cod_entidade",            limit: 100
        t.string   "no_entidade",             limit: 100
        t.string   "cod_orgao_regional_inep", limit: 10
        t.integer  "dependencia_adm"
        t.datetime "created_at"
        t.datetime "updated_at"
      end

      add_index "schools", ["cod_entidade"], name: "idx_schools_co_entidade", using: :btree
      add_index "schools", ["no_entidade"], name: "idx_schools_name_school", using: :btree
    end
      
    if !ActiveRecord::Base.connection.table_exists? 'semesters'
      create_table "semesters", force: true do |t|
        t.integer "graduation_profile_id"
        t.integer "number_semester",       default: 0
      end

      add_index "semesters", ["graduation_profile_id"], name: "idx_semesters", using: :btree
    end 
     
    if !ActiveRecord::Base.connection.table_exists? 'ufs'
      create_table "ufs", force: true do |t|
        t.string   "sigla",      limit: 2
        t.string   "name",       limit: 100
        t.datetime "created_at"
        t.datetime "updated_at"
        t.integer  "co_uf"
        t.integer  "region_id"
      end

      add_index "ufs", ["co_uf"], name: "idx_ufs_co_uf", using: :btree
      add_index "ufs", ["region_id"], name: "idx_ufs", using: :btree
    end
      
    if !ActiveRecord::Base.connection.table_exists? 'user_profiles'
      create_table "user_profiles", force: true do |t|
        t.integer  "user_id"
        t.string   "name"
        t.date     "birthday"
        t.text     "picture"
        t.string   "gender",         limit: 10
        t.string   "fb_uid"
        t.datetime "created_at"
        t.datetime "updated_at"
        t.integer  "school_id"
        t.integer  "scholarity"
        t.string   "grade",          limit: 50
        t.text     "enterprise_job"
        t.text     "job_title"
        t.integer  "semester"
        t.integer  "institution_id"
        t.integer  "graduation_id"
        t.string   "city"
        t.boolean  "student_loan"
      end

      add_index "user_profiles", ["user_id"], name: "index_user_profiles_on_user_id", using: :btree
    end
      
    if !ActiveRecord::Base.connection.table_exists? 'users'
      create_table "users", force: true do |t|
        t.string   "email",                             default: "",    null: false
        t.string   "encrypted_password",                default: "",    null: false
        t.string   "reset_password_token"
        t.datetime "reset_password_sent_at"
        t.datetime "remember_created_at"
        t.datetime "confirmed_at"
        t.integer  "sign_in_count",                     default: 0,     null: false
        t.datetime "current_sign_in_at"
        t.datetime "last_sign_in_at"
        t.string   "current_sign_in_ip"
        t.string   "last_sign_in_ip"
        t.string   "provider"
        t.string   "confirmation_token"
        t.time     "confirmation_sent_at"
        t.string   "unconfirmed_email"
        t.integer  "failed_attempts",                   default: 0,     null: false
        t.string   "unlock_token"
        t.datetime "locked_at"
        t.datetime "password_expires_at"
        t.datetime "created_at"
        t.datetime "updated_at"
        t.string   "registration_ip",                   limit: 15
        t.boolean  "agree_use_term"
        t.boolean  "answered",                          default: false
        t.boolean  "fake",                              default: false
      end

      add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
      add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    end  

    if !ActiveRecord::Base.connection.table_exists? 'videos'
      create_table "videos", force: true do |t|
        t.integer  "user_id"
        t.integer  "opinion_type_id"
        t.integer  "institution_id"
        t.integer  "graduation_id"
        t.string   "uuid"
        t.string   "short_code"
        t.integer  "views",           default: 0
        t.string   "youtube_code"
        t.integer  "youtube_views"
        t.boolean  "deleted"
        t.datetime "created_at"
        t.datetime "updated_at"
        t.boolean  "published"
      end

      add_index "videos", ["graduation_id"], name: "idx_videos_0", using: :btree
      add_index "videos", ["institution_id"], name: "idx_videos", using: :btree
      add_index "videos", ["opinion_type_id"], name: "index_videos_on_opinion_type_id", using: :btree
      add_index "videos", ["user_id"], name: "index_videos_on_user_id", using: :btree
    end
  end  

  def down
    # Do nothing
  end
end
