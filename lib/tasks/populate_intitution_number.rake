namespace :migrate do
  desc "Populate field 'institutions_numbers' from 'GraduationGroup'"
  task :institutions_numbers => :environment do
    GraduationGroup.includes(:institutions).each do |graduation|
      graduation.update(institutions_numbers: graduation.institutions.distinct.count)
    end 

    puts "Success!"
  end
end