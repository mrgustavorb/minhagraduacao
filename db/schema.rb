# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141007162728) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "academic_degrees", force: true do |t|
    t.string   "name",       limit: nil
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "academic_organizations", force: true do |t|
    t.integer  "co_organizacao_academica"
    t.string   "name",                     limit: nil
    t.string   "url_friendly",             limit: nil
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "cities_institutions", force: true do |t|
    t.integer "city_id"
    t.integer "institution_id"
  end

  add_index "cities_institutions", ["city_id"], name: "idx_graduations_institutions_2", using: :btree
  add_index "cities_institutions", ["institution_id"], name: "idx_graduations_institutions_1", using: :btree

  create_table "customer_profiles", force: true do |t|
    t.integer  "customer_id",                     null: false
    t.string   "name",                limit: nil
    t.string   "avatar_file_name",    limit: nil
    t.string   "avatar_content_type", limit: nil
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "customer_profiles", ["customer_id"], name: "idx_customer_profiles", using: :btree

  create_table "customers", force: true do |t|
    t.string   "role",                   limit: 100
    t.string   "email",                  limit: nil, default: "", null: false
    t.string   "encrypted_password",     limit: nil, default: "", null: false
    t.string   "reset_password_token",   limit: nil
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: nil
    t.string   "last_sign_in_ip",        limit: nil
    t.string   "confirmation_token",     limit: nil
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: nil
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "customers", ["confirmation_token"], name: "index_school_users_on_confirmation_token", unique: true, using: :btree
  add_index "customers", ["email"], name: "index_clients_on_email", unique: true, using: :btree
  add_index "customers", ["reset_password_token"], name: "index_clients_on_reset_password_token", unique: true, using: :btree

  create_table "disciplines", force: true do |t|
    t.integer "semester_id"
    t.string  "name",        limit: 100
    t.integer "hours"
  end

  add_index "disciplines", ["semester_id"], name: "idx_disciplines", using: :btree

  create_table "employee_profiles", force: true do |t|
    t.integer  "employee_id"
    t.string   "name",        limit: nil
    t.text     "bios"
    t.text     "picture"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "employee_profiles", ["employee_id"], name: "idx_employee_profiles", using: :btree

  create_table "employees", force: true do |t|
    t.string   "email",                  limit: nil, default: "", null: false
    t.string   "encrypted_password",     limit: nil, default: "", null: false
    t.string   "reset_password_token",   limit: nil
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: nil
    t.string   "last_sign_in_ip",        limit: nil
  end

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

  create_table "favorite_graduations", force: true do |t|
    t.integer  "user_id"
    t.integer  "graduation_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorite_graduations", ["user_id"], name: "index_user_profiles_on_user_id_0", using: :btree

  create_table "favorite_institutions", force: true do |t|
    t.integer  "user_id"
    t.integer  "institution_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorite_institutions", ["user_id"], name: "index_user_profiles_on_user_id_1", using: :btree

  create_table "graduation_groups", force: true do |t|
    t.string   "name",                 limit: nil
    t.string   "name_noaccent",        limit: nil
    t.string   "url_friendly",         limit: nil
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "views",                            precision: 20, scale: 0
    t.text     "json_data"
    t.text     "description"
    t.string   "source",               limit: nil
    t.integer  "institutions_numbers",                                      default: 0
  end

  add_index "graduation_groups", ["name_noaccent"], name: "idx_graduation_groups_name_noaccent", using: :btree

  create_table "graduation_profiles", force: true do |t|
    t.integer "graduation_institution_id"
    t.text    "description"
    t.text    "coordination"
    t.string  "period",                    limit: 100
    t.text    "hours"
    t.string  "monthly_payment",           limit: 100
    t.string  "video_link",                limit: nil
  end

  add_index "graduation_profiles", ["graduation_institution_id"], name: "idx_graduation_profiles", using: :btree

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

  create_table "institution_photos", force: true do |t|
    t.integer  "institution_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name",    limit: nil
    t.string   "photo_content_type", limit: nil
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "institution_photos", ["institution_id"], name: "idx_institution_profiles_0", using: :btree

  create_table "institution_profiles", force: true do |t|
    t.integer  "institution_id"
    t.text     "description"
    t.integer  "igc",                                    default: 0
    t.boolean  "accepts_fies",                           default: false
    t.boolean  "accepts_prouni",                         default: false
    t.integer  "total_professors_phd",                   default: 0
    t.integer  "total_professors_master",                default: 0
    t.integer  "total_professors_graduatos",             default: 0
    t.string   "site",                       limit: nil
    t.string   "video_link",                 limit: nil
    t.text     "email"
    t.string   "phone",                      limit: nil
    t.string   "address",                    limit: nil
    t.string   "url_facebook",               limit: nil
    t.string   "url_twitter",                limit: nil
    t.string   "url_youtube",                limit: nil
    t.string   "url_instagram",              limit: nil
    t.string   "url_google_plus",            limit: nil
    t.string   "avatar_file_name",           limit: nil
    t.string   "avatar_content_type",        limit: nil
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cep",                        limit: 50
  end

  add_index "institution_profiles", ["institution_id"], name: "idx_institution_profiles", using: :btree

  create_table "institutions", force: true do |t|
    t.string   "name",                     limit: nil
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
    t.integer  "academic_organization_id"
    t.integer  "views",                                default: 0
    t.integer  "customer_id"
  end

  add_index "institutions", ["academic_organization_id"], name: "idx_institutions_0", using: :btree
  add_index "institutions", ["customer_id"], name: "index_institutions_on_customer_id", using: :btree
  add_index "institutions", ["uf_id"], name: "idx_institutions", using: :btree

  create_table "method_teachings", force: true do |t|
    t.string   "name",       limit: nil
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pg_search_documents", force: true do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type", limit: nil
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: true do |t|
    t.string   "title",        limit: nil
    t.text     "content"
    t.string   "url_friendly", limit: nil
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regions", force: true do |t|
    t.string   "name",       limit: 100
    t.string   "region",     limit: nil
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "semesters", force: true do |t|
    t.integer "graduation_profile_id"
    t.integer "number_semester",       default: 0
  end

  add_index "semesters", ["graduation_profile_id"], name: "idx_semesters", using: :btree

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

  create_table "user_profiles", force: true do |t|
    t.integer  "user_id"
    t.string   "name",           limit: nil
    t.date     "birthday"
    t.text     "picture"
    t.string   "gender",         limit: 10
    t.string   "fb_uid",         limit: nil
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
    t.string   "city",           limit: nil
    t.boolean  "student_loan"
  end

  add_index "user_profiles", ["user_id"], name: "index_user_profiles_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  limit: nil, default: "",    null: false
    t.string   "encrypted_password",     limit: nil, default: "",    null: false
    t.string   "reset_password_token",   limit: nil
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "confirmed_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: nil
    t.string   "last_sign_in_ip",        limit: nil
    t.string   "provider",               limit: nil
    t.string   "confirmation_token",     limit: nil
    t.time     "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: nil
    t.integer  "failed_attempts",                    default: 0,     null: false
    t.string   "unlock_token",           limit: nil
    t.datetime "locked_at"
    t.datetime "password_expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "registration_ip",        limit: 15
    t.boolean  "agree_use_term"
    t.boolean  "answered",                           default: false
    t.boolean  "fake",                               default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "videos", force: true do |t|
    t.integer  "user_id"
    t.integer  "opinion_type_id"
    t.integer  "institution_id"
    t.integer  "graduation_id"
    t.string   "uuid",            limit: nil
    t.string   "short_code",      limit: nil
    t.integer  "views",                       default: 0
    t.string   "youtube_code",    limit: nil
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
