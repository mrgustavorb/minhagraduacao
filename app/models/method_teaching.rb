# == Schema Information
#
# Table name: method_teachings
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class MethodTeaching < ActiveRecord::Base
  def self.to_graduation(graduation_group_id)
    GraduationGroup.select('method_teachings.id, method_teachings.name')
                   .distinct
                   .joins(:method_teachings)
                   .where(graduation_groups: {id: graduation_group_id})
                   .order('method_teachings.id ASC')                     
  end  
end
