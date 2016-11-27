namespace :populate do
  desc "Pupulate Researchs"
  task :evaluations => :environment do

    require 'faker'
    
    987.times do |time|

      # Create user FAKE!
      user_fake                         = User.new 
      user_fake.fake                    = true
      user_fake.email                   = Faker::Internet.email
      user_fake.password                = user_fake.password_confirmation = '12345678'
      user_fake.confirmed_at            = Time.now
      user_fake.user_profile_attributes = {
        name: Faker::Name.name,
        scholarity: 2,
        gender: [:male, :female].sample
      }
      user_fake.save!

      case user_fake.user_profile.scholarity       
        
        # Research Students 
        when 1

          user_fake.user_profile.school_id = 1587216
          user_fake.user_profile.grade     = '3_medio'

          # Evaluation Schools 
          evaluation_school                     = EvaluationSchool.new
          evaluation_school.school_id           = user_fake.user_profile.school_id
          evaluation_school.user_id             = user_fake.id
          evaluation_school.security            = rand(10)
          evaluation_school.teachers            = rand(10)
          evaluation_school.coordinator         = rand(10)
          evaluation_school.laboratory          = rand(10)
          evaluation_school.physical_structure  = rand(10)
          evaluation_school.classmates          = rand(10)
          evaluation_school.methodology         = rand(10)
          evaluation_school.extra_activities    = rand(10)
          evaluation_school.recommendation      = rand(10)
          evaluation_school.save!

          # Favorite Graduations
          GraduationGroup.limit(3).order("RANDOM()").each do |graduation|
            favorite_graduation                     = FavoriteGraduation.new
            favorite_graduation.user_id             = user_fake.id
            favorite_graduation.graduation_group_id = graduation.id
            favorite_graduation.save!
          end
          
          # Favorite Instituions
          Institution.limit(3).order("RANDOM()").each do |institution|
            favorite_institution                = FavoriteInstitution.new
            favorite_institution.user_id        = user_fake.id
            favorite_institution.institution_id = institution.id
            favorite_institution.save!
          end 

          # Evaluation Institutions 
          evaluation_institutions                           = EvaluationInstitution.new
          evaluation_institutions.user_id                   = user_fake.id
          evaluation_institutions.accreditation             = rand(10)
          evaluation_institutions.infrastructure            = rand(10)
          evaluation_institutions.professor                 = rand(10)
          evaluation_institutions.coordinator               = rand(10)
          evaluation_institutions.money                     = rand(10)
          evaluation_institutions.level_students            = rand(10)
          evaluation_institutions.extra_activities          = rand(10)
          evaluation_institutions.sports_activities         = rand(10)
          evaluation_institutions.academic_exchange         = rand(10)
          evaluation_institutions.save!

        # Research Academics
        when 2

          #Profile
          user_fake.user_profile.institution_id = 619 # UNIFOR
          # user_fake.user_profile.institution_id = Institution.limit(1).order("RANDOM()").map(&:id)[0]
          user_fake.user_profile.graduation_id  = 47 # ADMINISTRACAO
          user_fake.user_profile.semester       = rand(1..14)
          user_fake.user_profile.city           = Faker::Address.city
          user_fake.save!


          # Evaluation Graduation 
          evaluation_graduations                       = EvaluationGraduation.new
          evaluation_graduations.user_id               = user_fake.id
          evaluation_graduations.graduation_group_id   = 47  # ADMINISTRACAO

          evaluation_graduations.social_recognition      = rand(8..10)
          evaluation_graduations.graduation_difficulty   = rand(6..8)
          evaluation_graduations.renumbered_training     = rand(4..6)
          evaluation_graduations.first_job               = rand(2..6)
          evaluation_graduations.job_most_areas          = rand(0..2)
          evaluation_graduations.tendering               = rand(5..10)
          evaluation_graduations.advantage               = Faker::Lorem.paragraph
          evaluation_graduations.disadvantage            = Faker::Lorem.paragraph
          evaluation_graduations.recommendation          = rand(4..8)
          evaluation_graduations.save!

          # Evaluation Institution
          evaluation_institutions                       = EvaluationInstitution.new
          evaluation_institutions.user_id               = user_fake.id
          evaluation_institutions.accreditation         = rand(10)
          evaluation_institutions.website_academic      = rand(10)
          evaluation_institutions.professor             = rand(10)
          evaluation_institutions.level_students        = rand(10)
          evaluation_institutions.money                 = rand(10)
          evaluation_institutions.student_organizations = rand(10)
          evaluation_institutions.sector_stage          = rand(10)
          evaluation_institutions.security              = rand(10)
          evaluation_institutions.pratical_activities   = rand(10)
          evaluation_institutions.academic_exchange     = rand(10)
          evaluation_institutions.advantage             = Faker::Lorem.paragraph
          evaluation_institutions.disadvantage          = Faker::Lorem.paragraph
          evaluation_institutions.infrastructure        = rand(10)
          evaluation_institutions.recommendation        = rand(10)
          evaluation_institutions.save!

        # when 3
        #   professionals_research_path
      end

    end

  end
end