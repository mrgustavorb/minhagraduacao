# == Schema Information
#
# Table name: disciplines
#
#  id          :integer          not null, primary key
#  semester_id :integer
#  name        :string(100)
#  hours       :integer
#

class Discipline < ActiveRecord::Base
    has_and_belongs_to_many :semesters
end
