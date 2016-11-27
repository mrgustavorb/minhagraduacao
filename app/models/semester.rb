# == Schema Information
#
# Table name: semesters
#
#  id                    :integer          not null, primary key
#  graduation_profile_id :integer
#  number_semester       :integer          default(0)
#

class Semester < ActiveRecord::Base
  belongs_to :graduation_profile
  has_many :disciplines
end
