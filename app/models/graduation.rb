# == Schema Information
#
# Table name: graduations
#
#  name                :string(200)
#  name_noaccent       :string(200)
#  url_friendly        :string(200)
#  active              :boolean
#  updated_at          :datetime
#  created_at          :datetime
#  no_curso            :string(200)
#  load_code           :string(100)
#  id                  :integer          not null, primary key
#  graduation_group_id :integer
#

class Graduation < ActiveRecord::Base
  
  # Relationships
  # -------------  
  has_many :videos
  
  has_many :graduations_institutions
  has_many :institutions, :through => :graduations_institutions
  has_one  :method_teachings, :through => :graduations_institutions
  
  belongs_to :graduation_group

  has_one :profile, :class_name => "GraduationProfile", :foreign_key => "graduation_institution_id", :primary_key => 'graduation_institution_id'

  def self.top_searches
    result = GraduationGroup.order('views desc').limit(6)
  end

end
