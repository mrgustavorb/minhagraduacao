# == Schema Information
#
# Table name: graduations_institutions
#
#  id                 :integer          not null, primary key
#  institution_id     :integer
#  graduation_id      :integer
#  co_curso           :integer
#  academic_degree_id :integer
#  method_teaching_id :integer
#

class GraduationsInstitution < ActiveRecord::Base
  belongs_to :institution
  belongs_to :graduation
  belongs_to :academic_degree
  belongs_to :method_teaching
  has_one    :profile, :class_name => "GraduationProfile", :foreign_key => "graduation_institution_id"
end
