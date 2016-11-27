# == Schema Information
#
# Table name: evaluation_graduations
#
#  id                      :integer          not null, primary key
#  graduation_group_id     :integer
#  user_id                 :integer
#  graduation_professional :integer
#  social_recognition      :integer
#  graduation_difficulty   :integer
#  renumbered_training     :integer
#  first_job               :integer
#  job_most_areas          :integer
#  tendering               :integer
#  starting_salary         :integer
#  professional_salary     :integer
#  advantage               :text
#  disadvantage            :text
#  recommendation          :integer
#  created_at              :datetime
#  updated_at              :datetime
#

class EvaluationGraduation < ActiveRecord::Base

  # Relationships
  # -------------
  belongs_to :user
  belongs_to :graduation_group

  scope :academics_evaluations, -> { joins(:user).merge(User.academics) }
  scope :professionals_evaluations, -> { joins(:user).merge(User.professionals) }
  
end
