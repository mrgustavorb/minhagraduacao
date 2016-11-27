# == Schema Information
#
# Table name: evaluation_schools
#
#  id                 :integer          not null, primary key
#  school_id          :integer
#  user_id            :integer
#  security           :integer
#  teachers           :integer
#  coordinator        :integer
#  laboratory         :integer
#  classmates         :integer
#  methodology        :integer
#  extra_activities   :integer
#  sports_activities  :integer
#  recommendation     :integer
#  created_at         :datetime
#  updated_at         :datetime
#  physical_structure :integer
#

class EvaluationSchool < ActiveRecord::Base

  # Relationships
  # -------------
  belongs_to :school
  belongs_to :user

end
