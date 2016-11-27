# == Schema Information
#
# Table name: favorite_graduations
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  graduation_group_id :integer
#  created_at          :datetime
#  updated_at          :datetime
#

class FavoriteGraduation < ActiveRecord::Base

  # Relationships
  # -------------
  belongs_to :user
  belongs_to :graduation_group

end
