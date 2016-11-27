# == Schema Information
#
# Table name: evaluation_institutions
#
#  id                    :integer          not null, primary key
#  user_id               :integer
#  accreditation         :integer
#  website_academic      :integer
#  level_students        :integer
#  money                 :integer
#  student_organizations :integer
#  sector_stage          :integer
#  security              :integer
#  infrastructure        :integer
#  academic_exchange     :integer
#  created_at            :datetime
#  updated_at            :datetime
#  professor             :integer
#  coordinator           :integer
#  pratical_activities   :integer
#  extra_activities      :integer
#  sports_activities     :integer
#  advantage             :text
#  disadvantage          :text
#  recommendation        :integer
#  institution_id        :integer
#

class EvaluationInstitution < ActiveRecord::Base

  # Relationships
  # -------------
  belongs_to :user
  belongs_to :user_profile, primary_key: "user_id", foreign_key: "user_id"

  scope :students,      -> { joins(:user_profile).where(user_profiles: {scholarity: 1}) }
  scope :academics,     -> { joins(:user_profile).where(user_profiles: {scholarity: 2}) }
  scope :professionals, -> { joins(:user_profile).where(user_profiles: {scholarity: 3}) }

end
