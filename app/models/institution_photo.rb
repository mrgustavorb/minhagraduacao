# == Schema Information
#
# Table name: institution_photos
#
#  id                 :integer          not null, primary key
#  institution_id     :integer
#  created_at         :datetime
#  updated_at         :datetime
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#

class InstitutionPhoto < ActiveRecord::Base
  
  # Relationships
  # -------------
  belongs_to :institution

  # Paperclip
  # -------------
  has_attached_file :photo, 
                    :styles => { :large => "720x530>", :thumb => "250x160>" }, 
                    :default_url => "/assets/university_school.png",
                    :path => '/:class/:institution_id/:style/:filename'

end
