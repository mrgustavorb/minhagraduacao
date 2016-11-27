# == Schema Information
#
# Table name: academic_degrees
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class AcademicDegree < ActiveRecord::Base
end
