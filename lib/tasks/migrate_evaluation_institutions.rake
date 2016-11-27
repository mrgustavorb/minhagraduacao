namespace :migrate do
  desc "Migrate evaluation institutions"
  task :evaluation_institutions => :environment do
   
    UserProfile.where('scholarity = ? OR scholarity = ?', 2, 3).each do |user_profile|
			if user_profile.user.answered
				e = EvaluationInstitution.find_by user_id: user_profile.user_id
				e.institution_id = user_profile.institution_id
				e.save!
			end
    end

  end
end