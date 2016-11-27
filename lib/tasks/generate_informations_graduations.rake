# encoding: utf-8

require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper

namespace :ninjachoice do
  desc "Generates informations in json graduations they are stored in the database"
  task generate_informations_graduations: :environment do

    GraduationGroup.all.each do |graduation_group|
        
        graduation_group.update_json_data
        graduation_group.save!

    end

  end
end