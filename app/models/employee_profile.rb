# == Schema Information
#
# Table name: employee_profiles
#
#  id          :integer          not null, primary key
#  employee_id :integer
#  name        :string(255)
#  bios        :text
#  picture     :text
#  created_at  :datetime
#  updated_at  :datetime
#

class EmployeeProfile < ActiveRecord::Base
  belongs_to :employee
end
